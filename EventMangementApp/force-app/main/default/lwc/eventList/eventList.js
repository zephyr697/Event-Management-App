import { LightningElement, track } from 'lwc';
import getUpcomingEvents from '@salesforce/apex/EventDetailService.getUpcomingEvents';

const columns = [
  {
    label: 'Event Name', fieldName: 'detailsPage', type: 'url', wrapText: true,
    typeAttributes: {
      label: { fieldName: "Name__c" },
      target: "_self"
    },
    cellAttributes: {
      iconName: "standard:event",
      iconPosition: "left"
    }
  },
  {
    label: 'Event Organizer', fieldName: 'EVNT_ORG',
    cellAttributes: {
      iconName: "standard:user",
      iconPosition: "left"
    }
  },
  {
    label: 'Location', fieldName: 'Location', type: 'text',
    cellAttributes: {
      iconName: "utility:location",
      iconPosition: "left"
    }
  },
  { label: 'Details', fieldName: 'Event_Detail__c', type: 'text', wrapText:true },

];

export default class EventList extends LightningElement {
  columnsList = columns;
  @track result;
  error;

  connectedCallback() { 
    this.getUpcomingEventsFromApex();
  }


  getUpcomingEventsFromApex() { 
    getUpcomingEvents()
    .then((data) => {
      data.forEach((event) => {
        // eslint-disable-next-line no-restricted-globals
        event.detailsPage =
          "https://" + window.location.host + "/" + event.Id;
        event.EVNT_ORG = event.Event_Organizer__r.Name;

        if (event.Location__c) {
          event.Location = event.Location__r.Name;
        } else {
          event.Location = 'This is a virtual event';
        }

      });

      this.result = data;
      this.error = undefined;
    }).catch((err) => {
      this.error = JSON.stringify(err);
      this.result = undefined;
      console.log('Error',this.error);
    });
  }

}
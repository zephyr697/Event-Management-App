import { LightningElement , track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import EVT_OBJECT from '@salesforce/schema/Event__c';
import Name from '@salesforce/schema/Event__c.Name__c';
import Event_Organizer__c from '@salesforce/schema/Event__c.Event_Organizer__c';
import Start_DateTime__c from '@salesforce/schema/Event__c.Start_DateTime__c';
import End_Date_Time__c from '@salesforce/schema/Event__c.End_Date_Time__c';
import Max_Seats__c from '@salesforce/schema/Event__c.Max_Seats__c';
import Location__c from '@salesforce/schema/Event__c.Location__c';
import Event_Detail__c from '@salesforce/schema/Event__c.Event_Detail__c';

import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AddEvent extends NavigationMixin(LightningElement) {

  @track eventRecord = {
    Name: '',
    Event_Organizer__c: '',
    Start_DateTime__c: null,
    End_Date_Time__c: null,
    Max_Seats__c: null,
    Location__c: null,
    Event_Detail__c:''
  }

  @track errors;

  handleChange(event) { 
    let value = event.target.value;
    let name = event.target.name;
    // window.console.log(name,value);
    this.eventRecord[name] = value;

  }

  handleLookup(event) { 
    let selectedRecId = event.detail.selectedRecordId;
    let parentField = event.detail.parentfield;
    // window.console.log(selectedRecId,parentField);

    this.eventRecord[parentField] = selectedRecId;
  }

  handleClick(event) { 
    const fields = {};
    fields[Name.fieldApiName] = this.eventRecord.Name;
    fields[Event_Organizer__c.fieldApiName] = this.eventRecord.Event_Organizer__c;
    fields[Start_DateTime__c.fieldApiName] = this.eventRecord.Start_DateTime__c;
    fields[End_Date_Time__c.fieldApiName] = this.eventRecord.End_Date_Time__c;
    fields[Max_Seats__c.fieldApiName] = this.eventRecord.Max_Seats__c;
    fields[Location__c.fieldApiName] = this.eventRecord.Location__c;
    fields[Event_Detail__c.fieldApiName] = this.eventRecord.Event_Detail__c;
    
    window.console.log('Fields',fields);

    const eventRecord = {
      apiName: EVT_OBJECT.objectApiName, fields };

    createRecord(eventRecord)
    .then((eventRec) => {
      this.dispatchEvent(new ShowToastEvent({
          title: 'Success',
          message: 'Event record was created.',
          variant: 'success'
      }));
      this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
          actionName: "view",
          recordId: eventRec.id
        }
      });
    }).catch((err) => {
      // alert('Error Occured'+ error);
      // window.console.log('Error ',error);
      this.errors = JSON.stringify(err);
      this.dispatchEvent(new ShowToastEvent({
          title: 'An Error occured.',
          message: this.errors,
          variant: 'error'
      }));
    });
  }

  handleCancel(event) {
    this[NavigationMixin.Navigate]({
        type: 'standard__objectPage',
        attributes: {
            actionName: "home",
            objectApiName: EVT_OBJECT.objectApiName
        }
    });
  }

}
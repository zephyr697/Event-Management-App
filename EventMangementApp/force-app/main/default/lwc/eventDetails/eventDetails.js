import { LightningElement,api,track } from 'lwc';
import getSpeakers from '@salesforce/apex/EventDetailsController.getSpeakers';
import getLocationDetails from '@salesforce/apex/EventDetailsController.getLocationDetails';
import getAttendees from '@salesforce/apex/EventDetailsController.getAttendees';

const columns = [
  {label:'Name',fieldName:'Name'},
  {label:'Email',fieldName:'Email', type:'email'},
  {label:'Phone',fieldName:'Phone', type:'phone'},
  {label:'Company Name',fieldName:'CompanyName'},
  
];

const columnsAtt = [
  {label:'Name',fieldName:'Name'},
  {label:'Email',fieldName:'Email', type:'email'},
  {label:'Company Name',fieldName:'CompanyName'},
  {label:'Location',fieldName:'Location'},
  
];

export default class EventDetails extends LightningElement {

  @api recordId;
  @track speakerList;
  @track eventRec;
  @track attendeesList;
  errors;
  columnsList = columns;
  columnAtt = columnsAtt;

  handleSpeakerActive(){

    getSpeakers({
      eventId : this.recordId
    })
    .then((results) => {
      this.speakerList = results;
      results.forEach((speaker) =>{
        speaker.Name = speaker.Speaker__r.Name;
        speaker.Email = speaker.Speaker__r.Email__c;
        speaker.Phone = speaker.Speaker__r.Phone__c;
        speaker.CompanyName = speaker.Speaker__r.Company__c;
      });
      this.errors = undefined;
    })
    .catch((err) =>{
      this.errors = err;
      this.speakerList = undefined;
    })
  }


  handleAttendeeDetails(){
    getAttendees({
      eventId : this.recordId
    })
    .then((result) => {
      
      result.forEach(att => {
        att.Name = att.Attendee__r.Name;
        att.Email = att.Attendee__r.Email__c;
        att.CompanyName = att.Attendee__r.Company_Name__c;
        if(att.Attendee__r.Location__c){
          att.Location = att.Attendee__r.Location__r.Name;
        }else{
          att.Location = 'Not available';
        }
      });
      this.attendeesList = result;
      this.errors = undefined;
    })
    .catch((err) =>{
      this.errors = err;
      this.attendeesList = undefined;
    })
  }


  handleLocationDetails(){
    getLocationDetails({
      eventId : this.recordId
    })
    .then((result) => {
      console.log('in handleLocationDetails',result);
      if(result.Location__c){
        this.eventRec = result;
        console.log(this.eventRec);
      }else{
        this.eventRec = undefined;
      }
      
    })
    .catch((err) =>{
      this.errors = err;
      this.speakerList = undefined;
    })
  }

}
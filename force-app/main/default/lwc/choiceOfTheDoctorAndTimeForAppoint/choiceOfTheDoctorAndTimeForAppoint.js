import { LightningElement, wire } from 'lwc';
import getDoctors from '@salesforce/apex/CreateNewAppointmentClass.getDoctors';
import getDates from '@salesforce/apex/CreateNewAppointmentClass.getDates';
import getAvailableTime from '@salesforce/apex/CreateNewAppointmentClass.getAvailableTime';
import setNewAppointment from '@salesforce/apex/CreateNewAppointmentClass.setNewAppointment';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

export default class ChoiceOfTheDoctorAndTimeForAppoint extends LightningElement {
    doctors = [];
    dates = [];
    availableTime = [];
    doctorId = '';
    dateValue = '';
    timeValue = '';
    clientId = '';
    serviceId = '';

    connectedCallback() {
        this.fetchDoctors();
    }

    fetchDoctors() {
        getDoctors().then(result => {
            if(result) {
                this.doctors = result;
            }
        });
    }

    handleDoctorChange(event) {
        this.dateValue = null;
        this.timeValue = null;
        this.dates = [];
        this.availableTime = [];
        this.doctorId = event.detail.value;
        getDates({id: this.doctorId}).then(result => {
            if(result && result.length != 0) {
                this.dates = result;
            }
        });
       
    }

    handleDateChange(event) {
        this.timeValue = null;
        this.availableTime = [];
        this.dateValue = event.detail.value;
        getAvailableTime({id: this.doctorId, dateValue: this.dateValue}).then(result => {
            if(result) {
                this.availableTime = result;
            }
        });
    }

    handleTimeChange(event) {
        this.timeValue = event.detail.value;
    }

    handleClientChange(event) {
        this.clientId = event.target.value;
    }

    handleServiceChange(event) {
        this.serviceId = event.target.value;
    }

    saveNewAppointment() {
        setNewAppointment({appointTime: this.timeValue, appointDate: this.dateValue, clientId: this.clientId, serviceId: this.serviceId, doctorId: this.doctorId}).then(result => {
            if(result) {
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'Your data has been successfully saved!',
                    variant: 'success',
                });
                this.dispatchEvent(evt);

                this.doctorId = null;
                this.dateValue = null;
                this.timeValue = null; 
                this.availableTime = [];          
                const lwcInputFields = this.template.querySelectorAll('lightning-input-field');
                lwcInputFields.forEach(field => {
                    field.reset();
                });
            }
        })

     
    }
}
public class CreateNewAppointmentClass {
    private static List<Client__c> clientsList = [SELECT Id, Name, VIP__c FROM Client__c];

    private static Map<Id, Doctor__c> doctorWithAppointmentsMap = new Map<Id, Doctor__c>([
        SELECT Id, End_of_work__c, Star_of_work__c, 
            (SELECT Time__c, Date__c FROM Appointments__r) 
        FROM Doctor__c
    ]);
    
    
    @AuraEnabled(cacheable=true)
    public static List<PiclistValues> getDoctors() {
        List<Doctor__c> doctorsList = [SELECT Id, Name FROM Doctor__c];
        List<PiclistValues> newDoctorsList = new List<PiclistValues>();
        for (Doctor__c doctor: doctorsList) {
            PiclistValues newDoctor = new PiclistValues();
            newDoctor.value = doctor.Id;
            newDoctor.label = doctor.Name;
            newDoctorsList.add(newDoctor);
        }
        return newDoctorsList;
    }

    @AuraEnabled(cacheable=true)
    public static List<PiclistValues> getDates(String id) {
        List<Schedule__c> datesList = [SELECT Working_day__c, Doctor__c FROM Schedule__c WHERE Doctor__c =: id AND Working_day__c >=: System.today() ORDER BY Working_day__c ASC LIMIT 7];
        List<PiclistValues> newDatesList = new List<PiclistValues>();
        for (Schedule__c workingDate: datesList) {
            PiclistValues newDate = new PiclistValues(); 
            String stringDate = String.valueOf(workingDate.Working_day__c);
            newDate.value = stringDate;
            newDate.label = stringDate;
            newDatesList.add(newDate);
        }
        return newDatesList;
    }

    @AuraEnabled
    public static List<PiclistValues> getAvailableTime(String id, String dateValue){
        Date dateOfWork = Date.valueOf(dateValue + ' 00:00:00');
        List<Time> appointmentsTimeList = new List<Time>();
        for (Appointment__c appoint: doctorWithAppointmentsMap.get(id).Appointments__r) {
            if (appoint.Date__c == dateOfWork) {
                appointmentsTimeList.add(appoint.Time__c);
            }
        }
        List<PiclistValues> newTimeList = new List<PiclistValues>();
        while (doctorWithAppointmentsMap.get(id).Star_of_work__c < doctorWithAppointmentsMap.get(id).End_of_work__c) {
            if (!appointmentsTimeList.contains(doctorWithAppointmentsMap.get(id).Star_of_work__c)) {
                String stringTime = (String.valueOf(doctorWithAppointmentsMap.get(id).Star_of_work__c)).substring(0, 5);
                PiclistValues newTime = new PiclistValues();
                newTime.value = stringTime;
                newTime.label = stringTime;
                newTimeList.add(newTime);
            }
            doctorWithAppointmentsMap.get(id).Star_of_work__c = doctorWithAppointmentsMap.get(id).Star_of_work__c.addHours(1);
        }
        return newTimeList;
    } 



    @AuraEnabled
    public static String setNewAppointment(String appointTime, String appointDate, String clientId, String serviceId, String doctorId) {
        try {
            Appointment__c newAppointment = new Appointment__c();
            for (Client__c client: clientsList) {
                if (client.Id == clientId) {
                    newAppointment.Name = client.Name + ' appointment';
                    newAppointment.Client__c = client.Id;
                    newAppointment.Service__c = serviceId;
                    newAppointment.Doctor__c = doctorId;
                    newAppointment.Date__c = Date.valueOf(appointDate + ' 00:00:00');
                    newAppointment.Time__c = Time.newInstance(Integer.valueOf(appointTime.substring(0,2)),
                                                            Integer.valueOf(appointTime.substring(3,5)),
                                                            00,
                                                            00);
                    newAppointment.Payed__c = getCurrentPrice(serviceId);
                    if (client.VIP__c == true) {
                        newAppointment.Payed__c = getCurrentPrice(serviceId) * 0.85;
                    }
                }
            }
            insert newAppointment;
            return 'Appointment was inserted';
        } catch (Exception ex) {
            return 'Inserting was failed' + ex;
        }
        
    } 

    public static Decimal getCurrentPrice(String ids) {
        Service__c listOfServices = [SELECT Id, Price__c FROM Service__c WHERE Id =: ids];
        return listOfServices.Price__c;
    }

    public class PiclistValues{
        @AuraEnabled
        public String value;
        @AuraEnabled
        public String label;
    }

}
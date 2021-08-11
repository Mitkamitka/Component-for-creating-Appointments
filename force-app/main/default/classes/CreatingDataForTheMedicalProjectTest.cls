@isTest
public class CreatingDataForTheMedicalProjectTest {

    @isTest
    public static void creatingRecords() {
        List<Service__c> newServiceList = new List<Service__c>{
            new Service__c(Name = 'Operation', Price__c = 320),
            new Service__c(Name = 'Diagnostic', Price__c = 35),
            new Service__c(Name = 'Dressing', Price__c = 20)
        };
        insert newServiceList;
        Test.startTest();
        CreatingDataForTheMedicalProject.createMedicalData(100, 200);
        Test.stopTest();

        List<Client__c> listOfClientsAndAppointments = [SELECT Name, Age__c, VIP__c, Email__c, Mobile__c, 
                                        (SELECT Name, Client__c, Service__c, Payed__c, Date__c FROM Appointments__r) 
                                        FROM Client__c ];

        List<Client__c> listOfVIPClients = new List<Client__c>();
        List<Client__c> listOfClientsWithMobile = new List<Client__c>();
        List<Client__c> listOfClientsWithEmail = new List<Client__c>();

        for (Client__c client: listOfClientsAndAppointments) {
            if (client.VIP__c == true) {
                listOfVIPClients.add(client);
            } else if(client.Mobile__c != null) {
                listOfClientsWithMobile.add(client);
            } else if(client.Email__c != null) {
                listOfClientsWithEmail.add(client);
            } 
            System.assert(client.Age__c <= 90 && client.Age__c >= 0);
            System.assert(client.Appointments__r.size() >= 1);
            for (Appointment__c appoint: client.Appointments__r) {
                System.assert(appoint.Client__c == client.Id);
                // System.assert(appoint.Date__c > Date.today().addDays(-61) && appoint.Date__c < Date.today().addDays(28));
            }
        }
        System.assert(listOfVIPClients.size() < listOfClientsAndAppointments.size() && listOfClientsWithMobile.size() < listOfClientsAndAppointments.size() && listOfClientsWithEmail.size() < listOfClientsAndAppointments.size());
    } // создать докторов, у каждого должно быть свое расписание. В расписании должно быть начало работы и конец. В аппоинтменте нужно будет указывать доктора и время приема. Написать простенький компонент LWC
    // каждый визит это один час. В этом компоненте должен быть пиклист из докторов, пиклист из дат на неделю с сегодняшнего числа. В зависимости от выбора даты должны показываться свободные времена для записи - их 
    // вывести тоже пиклистом. 
}

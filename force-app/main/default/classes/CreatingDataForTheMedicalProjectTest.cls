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
    }
}

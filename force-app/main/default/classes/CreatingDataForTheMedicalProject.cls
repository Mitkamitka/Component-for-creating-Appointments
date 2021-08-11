public class CreatingDataForTheMedicalProject {
    private static List<String> firstNames = new List<String>{
        'Dmitry', 'Arseniy', 'Nikolay', 'Artem', 
        'Vasia', 'Kirill', 'Tolia', 'Nadia', 'Vika', 'Aleksandra', 'Rosa', 'Valentina',
        'Ksenia', 'Georgiy'
    };
    private static List<String> lastNames = new List<String>{
        'Sanko', 'Kekovich', 'Hehehovich', 'Fursa', 
        'Korshun', 'Astapko', 'Shuk', 'Fera', 'Ludko', 'Shapito', 'Karnaval', 'Oshenko',
        'Ktotam', 'Lolovich'
    };
    private static List<String> phoneCodesWithOperators = new List<String>{
        '+37525', '+93701', '+35569', '+21370', 
        '+54320', '+37491', '+43660', '+99450', '+97339', '+88018', '+32484', '+22997',
        '+38765', '+35998'
    };
    private static List<String> mails = new List<String>{
        '@mail.ru', '@icloud.com', '@gmail.com', '@yandex.ru', 
        '@vrp.com', '@kek.com', '@yoohoo.com', '@amazon.com', '@ozone.ru'
    };
    private static List<Client__c> newClientList = new List<Client__c>();
    private static List<Appointment__c> newAppointList = new List<Appointment__c>();
    private static List<Service__c> serviceList = [SELECT Name, Price__c FROM Service__c];
    private static Map<Id, Date> datesCounter = new Map<Id, Date>();

    private static Integer getMathRandom(Integer factor) {
        return Integer.valueOf(Math.random() * factor);
    }
    
    private static String createMobile() {
        String nums = '1234567890';
        String randMob = '';
        while (randMob.length()<7) {
            Integer randNum =  getMathRandom(nums.length());
            randMob += nums.substring(randNum, randNum+1);
        }
        return randMob;
    }

    private static void randomFillingOfMobileEmailVIP(Integer amountOfClients, Decimal percentageFraction, String fieldName) { //рандомит с заполнением полей клиентов
        Integer secondFillingOfClientsCounter = 1;
        Set<Integer> unicRandomValues = new Set<Integer>();
        while (secondFillingOfClientsCounter <= Integer.valueOf(Math.round(amountOfClients * percentageFraction))) { //процент клиентов у которых заполнятся филды
            Integer randomNumOfClient = getMathRandom(amountOfClients); 
            if (!unicRandomValues.contains(randomNumOfClient)) {
                if (fieldName == 'VIP') {
                    newClientList[randomNumOfClient].VIP__c = true;
                    unicRandomValues.add(randomNumOfClient);
                    secondFillingOfClientsCounter++;
                } else if (fieldName == 'Email') {
                    newClientList[randomNumOfClient].Email__c = lastNames.get(getMathRandom(lastNames.size())) + firstNames.get(getMathRandom(firstNames.size())) + mails.get(getMathRandom(mails.size()));
                    unicRandomValues.add(randomNumOfClient);
                    secondFillingOfClientsCounter++;
                } else if (fieldName == 'Mobile') {
                    newClientList[randomNumOfClient].Mobile__c = phoneCodesWithOperators.get(getMathRandom(phoneCodesWithOperators.size())) + createMobile();
                    unicRandomValues.add(randomNumOfClient);
                    secondFillingOfClientsCounter++;
                }
            }
        }
    }

    private static void createlistOfAppointments(Client__c client) { 
        Integer randomNumOfService =  getMathRandom((serviceList.size() - 1));
        Appointment__c newAppoint = new Appointment__c();
        newAppoint.Name = client.Name + ' ' + serviceList[randomNumOfService].Name; 
        newAppoint.Client__c = client.Id;
        newAppoint.Service__c = serviceList[randomNumOfService].Id;
        newAppoint.Payed__c = serviceList[randomNumOfService].Price__c;
        if (client.VIP__c) {
            newAppoint.Payed__c *= 0.8;
        }
        if (datesCounter.get(client.Id) == null || datesCounter.size() == 0) {
            newAppoint.Date__c = createRandomDateWithinTwoMonths();
            datesCounter.put(client.Id, createRandomDateWithinTwoMonths());
        } else {
            Date newDate = datesCounter.get(client.Id).addDays(getMathRandom(4) * 7);
            newAppoint.Date__c = newDate;
            datesCounter.put(client.Id, newDate);
        }
        newAppointList.add(newAppoint);
        
    }

    private static Date createRandomDateWithinTwoMonths() {
        Integer randomAddDaysValue = getMathRandom(61);
        Date result = date.today().addDays(-randomAddDaysValue);
        return result;
    }

    public static void createMedicalData(Integer amountOfClients, Integer amountOfAppointments) {
        Decimal sixtyPercentOfClientsEmailsMobiles = 0.6;
        Decimal fiftyPercentOfDiscount = 0.15;
        Set<String> setOfClientsName = new Set<String>();
        
        while (setOfClientsName.size() != amountOfClients) {
            Client__c newClient = new Client__c();
            String clientName = firstNames.get(getMathRandom(firstNames.size())) + ' ' + lastNames.get(getMathRandom(lastNames.size()));
            if (!setOfClientsName.contains(clientName)) {
                newClient.Name = clientName;
                newClient.Age__c = getMathRandom(90);
                newClientList.add(newClient);
                setOfClientsName.add(clientName);
            }
        }
        
        randomFillingOfMobileEmailVIP(amountOfClients, sixtyPercentOfClientsEmailsMobiles, 'Email');
        randomFillingOfMobileEmailVIP(amountOfClients, sixtyPercentOfClientsEmailsMobiles, 'Mobile');
        randomFillingOfMobileEmailVIP(amountOfClients, fiftyPercentOfDiscount, 'VIP');

        insert newClientList;

        for (Client__c client: newClientList) {
            createlistOfAppointments(client);
        }
   
        while (newAppointList.size() < amountOfAppointments) {
            Integer randomClientIndex = getMathRandom((amountOfClients-1));
            createlistOfAppointments(newClientList[randomClientIndex]);
        }
    
        insert newAppointList;
    }
}
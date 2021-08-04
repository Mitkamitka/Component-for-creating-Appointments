Decimal x = 60;
System.debug(Integer.valueOf(Math.round(x)));

List<String> newL = new List<String>{'1', '2','3','4','5','6','7'};
System.debug(newL[Integer.valueOf(Math.random()*newL.size())]);

String nums = '1234567890';
System.debug(nums.length());

String nums = '1234567890';
        String randMob = '';
        while (randMob.length()<7) {
            Integer randNum = Integer.valueOf(Math.random()*nums.length());
            randMob += nums.substring(randNum, randNum+1);
        }
        System.debug(randMob);


CreatingDataForTheMedicalProject.createMedicalData(3, 6);

List<Client__c> delC = [SELECT Id FROM Client__c];
delete delC;

List<Appointment__c> delA = [SELECT Id FROM Appointment__c];
delete delA;

List<Client__c> newC = [SELECT Name, (SELECT Name FROM Appointments__r) FROM Client__c];
for(Client__c cl: newC) {
    if (cl.Appointments__r != null) {
        System.debug(cl.Appointments__r.size());
    }
}

Datetime dt = System.now();
Date dateNow = dt.date().addDays(1);
System.debug(dateNow);



Boolean b = true;
for (Integer i = 0; i<=1; i++) {
    if (b) {
        System.debug(i);
        b = false;
    } else {
        System.debug(i);
        i--;
    }
}



List<Date> datesList = new List<Date>();
Integer counter = 0;
Integer daysInTwoMonth = 61;
Datetime dt = System.now();
Date dateNow =  dt.date();
while (counter <= daysInTwoMonth) {
    if (datesList.isEmpty()) {
        datesList.add(dateNow);
        counter++;
    } else {
        datesList.add(datesList.get(counter-1).addDays(-1));
        counter++;
    }
}
for (Date dateD : datesList) {
    System.debug(dateD);
}


Integer counter = 0;
while (counter <= 5) {
    System.debug(counter);
    counter++;
}

Datetime dt = System.now();
Date dateNow = dt.date();
if (dateNow < dateNow.addDays(2)) {
    System.debug('True');
} else {
    System.debug('False');
}

List<Integer> integ = new List<Integer>{2,3};
if (integ.get(2)) {
    System.debug('True');
} else {
    System.debug('Error');
}


Map<Integer, Service__c> mapOfServices = new Map<Integer, Service__c>();
Integer counterKeyForServicesMap = 0;
for (Service__c service: [SELECT Name, Price__c FROM Service__c]) {
    mapOfServices.put(counterKeyForServicesMap, service);
    counterKeyForServicesMap++;
}
System.debug(mapOfServices.get(1).Name);
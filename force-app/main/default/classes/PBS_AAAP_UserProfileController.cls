public with sharing class PBS_AAAP_UserProfileController {

    public User usrinfo { get; set; }
    public boolean isEdit { get; set; }
    // Variables used for User De-Registration
    public String userid { get; set; }
    public String pin { get; set; }
    public boolean isLOP { get; set; }


    public PBS_AAAP_UserProfileController() {
        string requestType = ApexPages.currentPage().getParameters().get('Type');
        if (requestType == 'LOP') {
            isLOP = true;
        } else {
            isLOP = false;
        }

        List<User> tempUsrinfo = [
                SELECT id, email, Name, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                        street, city, country, CompanyName, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email, contact.PBS_AAAP_Website__c,
                        PBS_AAAP_StatesOfInterest__c, PBS_AAAP_PIN__c,PBS_AAAP_Regions__c, PBS_AAAP_Alternate_Phone__c
                FROM User
                WHERE id = :UserInfo.getUserId()
        ];


        for (User u : tempUsrinfo) {
            usrinfo = u;
        }

    }

    public void save() {
        if (usrinfo.contact != null) {
            usrinfo.contact.title = usrinfo.title;
            usrinfo.contact.firstname = usrinfo.firstname;
            usrinfo.contact.lastname = usrinfo.lastname;
            usrinfo.contact.email = usrinfo.email;
            usrinfo.contact.phone = usrinfo.phone;
            usrinfo.contact.mobilephone = usrinfo.mobilephone;
            usrinfo.contact.mailingstreet = usrinfo.street;
            usrinfo.contact.mailingcity = usrinfo.city;
            usrinfo.contact.mailingstate = usrinfo.state;
            usrinfo.contact.mailingpostalcode = usrinfo.postalcode;
            usrinfo.contact.mailingcountry = usrinfo.country;
            usrinfo.contact.title = usrinfo.title;
            usrinfo.contact.PBS_AAAP_Company__c = usrinfo.CompanyName;
            usrinfo.contact.PBS_AAAP_Alternate_Phone__c = usrinfo.PBS_AAAP_Alternate_Phone__c;
            usrinfo.contact.PBS_AAAP_StatesOfInterest__c = usrinfo.PBS_AAAP_StatesOfInterest__c;
            usrinfo.PBS_AAAP_Regions__c = SiteRegisterController.selectRegions(usrinfo.PBS_AAAP_StatesOfInterest__c);
            usrinfo.contact.PBS_AAAP_Regions__c = usrinfo.PBS_AAAP_Regions__c;
        }

        try {
            update usrinfo;
            if (usrinfo.contact != null) {
                update usrinfo.contact;
            }
            isEdit = false;
        } catch (DmlException e) {
            ApexPages.addMessages(e);
        }
    }


    public void cancel() {
        isEdit = false;
        usrinfo = [
                SELECT id, email, Name, username, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                        street, city, country, CompanyName, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email, contact.PBS_AAAP_Website__c,
                        PBS_AAAP_StatesOfInterest__c, PBS_AAAP_PIN__c, PBS_AAAP_Regions__c, PBS_AAAP_Alternate_Phone__c
                FROM User
                WHERE id = :UserInfo.getUserId()
        ];
    }

    public PageReference actionredirecttoDeregister() {
        PageReference p = Page.PBS_AAAP_User_Deregistration;
        //p.getParameters().put('offerId', offerBuilding.Id);
        p.setRedirect(true);
        return p;

    }
    public Boolean getIsEdit() {
        return isEdit;
    }

    public void edit() {
        isEdit = true;
    }

    public PageReference actionDeRegistration() {
        PageReference p = null;
        if (userid != '' && pin != '') {
            System.debug('********** userid:::: ' + userid);
            System.debug('**********PIN:::: ' + pin);
            try {
                User usr = [SELECT id, Name, PBS_AAAP_PIN__c, username FROM User WHERE username = :userid AND PBS_AAAP_PIN__c = :pin];
                if (usr.id != null) {
                    System.debug('********** Future Method:::: ' + usr);
                    //makePortalUserInactive(userid);
                    // Send an email to email service handler
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String[] toAddresses = new String[]{
                            'email_service_for_deregistering_portal_user@7-4nadul3uf273h6wo1h6h7i19g.v1b8cmaa.v.apex.sandbox.salesforce.com'
                    };
                    mail.setToAddresses(toAddresses);
                    mail.setReplyTo('aaap.manager@gsa.gov');
                    mail.setSenderDisplayName('User Support');
                    mail.setSubject('usr-' + usr.username);
                    mail.setPlainTextBody('aaap.manager@gsa.gov'); // mail.setPlainTextBody('sguni@acumensolutions.com');                 
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
                            mail
                    });


                    p = new PageReference('/secur/logout.jsp');
                    p.setRedirect(true);

                }
            } catch (Exception ex) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Either the userid or PIN is incorrect. Please try it again or contact AAAP Manager.');
                ApexPages.addMessage(myMsg);
                return null;
            }
        }

        return p;
    }


}
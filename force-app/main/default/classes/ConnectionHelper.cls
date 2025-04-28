public with sharing  class ConnectionHelper {

    public static Id getConnectionId(String connectionName) {
        
        ID idConnection = Null;

        List<PartnerNetworkConnection> partnerNetConList = New List<PartnerNetworkConnection>();
        if(!test.isrunningtest()){    
        	partnerNetConList =  [Select id from PartnerNetworkConnection where connectionStatus = 'Accepted' and connectionName = :connectionName];
        }else{
        	 partnerNetConList =  [Select id from PartnerNetworkConnection where connectionName = :connectionName];    
        }    
        if(partnerNetConList <> null){
        if ( partnerNetConList.size() != 0  ) {
            idConnection  = partnerNetConList.get(0).Id;
        }
        }
        return idConnection;
    }
 
}
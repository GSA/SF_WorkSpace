//Just pass this baby back into a component and it will create beautiful charts for you
// https://www.chartjs.org/docs/latest/
public with sharing class NCMT_Chart_JS {

    @AuraEnabled public String type {get;set;}
    @AuraEnabled public Data data {get;set;}
    @AuraEnabled public Options options {get;set;}
    @AuraEnabled public String uniqueId {get;set;}

    public NCMT_Chart_JS(String t){
        type = t;
        data = new Data();
        options = new Options();
    }

    public class Data{
        @AuraEnabled public List<String> labels {get;set;}
        @AuraEnabled public List<Dataset> datasets {get;set;}
        
        public Data(){
            labels = new List<String>();
            datasets = new List<Dataset>();
        }
    }

    public class Dataset{
        @AuraEnabled public String label {get;set;}
        @AuraEnabled public List<Double> data {get;set;}
        @AuraEnabled public List<String> backgroundColor {get;set;}
        //@AuraEnabled public List<String> borderColor {get;set;}
        //@AuraEnabled public String borderWidth {get;set;}

        public Dataset(){
            data = new List<Double>();
            backgroundColor = new List<String>();
        }

    }

    public class Options{
        @AuraEnabled public Scales scales {get;set;}
        @AuraEnabled public Title title {get;set;}
        @AuraEnabled public Legend legend {get;set;}
        @AuraEnabled public Boolean maintainAspectRatio {get;set;}
        //@AuraEnabled public String tooltipTemplate {get;set;}

        public Options(){
            Title = new Title();
            legend = new Legend();
            scales = new Scales();
            maintainAspectRatio = false;
        }
    }

    public class Title{
        @AuraEnabled public String text {get;set;}
        @AuraEnabled public Boolean display {get;set;}

        public Title(){
            display = true;
        }
    }

    public class Legend{
        @AuraEnabled public Boolean display {get;set;}

        public Legend(){
            display = false;
        }
    }

    public class Scales{
        @AuraEnabled public List<Axis> yAxes {get;set;}
        @AuraEnabled public List<Axis> xAxes {get;set;}

        public Scales(){
            yAxes = new List<Axis>();
            xAxes = new List<Axis>();
        }
    }

    public class Axis{
        //@AuraEnabled public List<Tick> ticks {get;set;}
        @AuraEnabled public Boolean stacked {get;set;}
        //@AuraEnabled public Boolean display {get;set;}

        public Axis(){ 
            //ticks = new List<Tick>();
            stacked = false;
            //display = true;
        }
    }
/*
    public class Tick{
        @AuraEnabled public Boolean beginAtZero {get;set;}

        public Tick(){
            beginAtZero = true;
        }
    }*/
}
public with sharing class PBS_AAAP_QuestionLabels {
    /*  Internal Use    */
    private PBS_AAAP_DAO_Utilities dao = new PBS_AAAP_DAO_Utilities();   // generate an instance of the DAO class
    private String newTiVal = '';
    private String usedTiVal = '';
    private String maxTiVal = '';
//---------RITM0021675, RITM002167, RITM0021677----------------------------------------------->                            
    private String BSAC_per_ABOAVal = '';
    private String BSAC_per_ABOAVal_continuing_space = '';
// Vaishali RLP FY 15    
    private String col2Header = '';
    private String Q6Text = '';
//Vaishali RLP FY15    
    private String col1Header = ''; // FY17 fix
    /*  Space and Rates Question Labels */
    public String maxTi { get {return this.maxTiVal;} }

    public String spaceQ1 { get {return '1. What is the total ANSI/BOMA Office Area (ABOA) square feet (SF) available for lease to the Government?';} }
    public String spaceQ2 { get {return '2. What is the max contiguous ABOA SF available?';} }
 // public String spaceQ3New { get {return '2. What is the total ANSI/BOMA Office Area (ABOA) square feet (SF) available for lease to the Government?';} }
 // Ramya reworded question2 Space and Rates on 09/13/2022
    public String spaceQ3New { get {return '2. What is the total ANSI/BOMA Occupant Area (ABOA) square feet (SF) available for lease to the Government?';} }
    public String spaceQ3Succ { get {return '1. Expiring GSA Lease Number:';} }
    public String spaceQ4New { get {return '3. What is the maximum contiguous ABOA SF available?';} }
    public String spaceQ4Succ { get {return '2. Total ANSI/BOMA Office Area (ABOA) square feet (SF) that is expiring:';} }
    public String spaceQ5 { get {return '5. What is the date of availability of space for commencement of tenant improvements?';} }
// Vaishali RLP FY15 07/31/2014 "Explanation for space type buttons New or Continuing"
// Vaishali RLP FY15 01/21/2015        public String spaceType1    { get { return  'For all new space click on Add New Space.  Offers with existing / expiring Government leases should click Add Continuing Need.';}  }
    public String spaceType1 { get {return 'For all new space click on Add New Space. Offerors with expiring Government leases should click Add Continuing Need.';} }
    public String spaceType2 { get {return 'All available space for lease should be entered below by clicking the Add Space button. Space may be entered as one lump block at the same rate OR multiple spaces within the building at different rates. If the space record already exists in the table below, do not click Add Space. Instead, work from the existing record below by selecting the radial button to the left of the record and selecting Edit.';} }
    public String validationMust { get {return 'Click on \'Validate Address\' every time you change address for the offer';} }
// End: Vaishali RLP FY15 07/31/2014 "Explanation for space type buttons New or Continuing"
//Vaishali --Q7 and Q8 anyway will no longer be shown        
//      public String spaceQ6       { get { return  '6. General Contractor\'s overhead and profit as a percentage of the initial tenant improvements up to $' + maxTiVal + ' per ABOA SF, including change orders, for the block of space offered*?';} }
//SGanti reworded and renumbered question Space and Rates question 15 on 7/15/2021    
    public String spaceQ6 { get {return '14. Lessor’s Project Management Fee (as a Percent of Total TI Construction Costs):';} }
    public String spaceQ7 { get {return '7. General Contractor\'s general conditions as a percentage of the initial tenant improvements, including change orders, for the block of space offered?';} }
    public String spaceQ8 { get {return '8. Offeror\'s construction management/coordination fees as a percentage of initial tenant improvements up to $' + maxTiVal + ' per ABOA SF, including change orders, for the block of space offered*?';} }
//Vaishali RLP FY14   
//SGanti reworded and renumbered question Space and Rates question 16 on 7/15/2021    
    public String spaceQ9 { get {return '15. Architectural and Engineering Fees (as a Dollar Amount per ABOA SF or Percent of Total TI Construction Costs):';} }
    public String spaceQ10 { get {return '6. The total cost of markups for the Lessor\'s overhead, administrative costs, profit, and fees and any other profit and/or fees charged against tenant improvements for recarpeting, or other tenant finish items not requiring architectural/engineering services.';} }
    public String spaceQ10Tot { get {return 'Total Mark-ups: ';} }
    public String spaceQ14 { get {return '14. Indicate the rental charge per ABOA SF to meet the "Routine Cleaning and Disinfecting Requirements for the Premises." as described in the "Janitorial Service" paragraph of the lease, sub-paragraph N. For offer and evaluation purposes, Offerors shall include this charge as part of the Shell rents (above).';} }
    //public String ratesQ1       { get { return  '1. Shell Rate per ANSI/BOMA Office Area (ABOA) square foot (SF) for the Warm-Lit Shell (excluding the cost of tenant improvements, services and utilities).';}  }
    public String ratesQ1 { get {return '7. Shell Rental Rate (Yrs 1 - 8)';} }
    public String ratesQ1Five { get {return '7. Shell Rental Rate (Yrs 1 - 5)';} }
    public String ratesQ1_Census { get {return '1. Shell Rental Rate';} }
    
    //public String ratesQ2       { get { return  '2. The Base Year Operating costs for services and utilities per ABOA SF.';}   }
    public String ratesQ2 { get {return '8. Base Year Operating Costs';} }
    //  public String ratesQ3New        { get { return  '3. The annual percentage rate (APR), compounded monthly, to be used by the Lessor to amortize the cost of the Tenant Improvements plus construction markups up to $'+ newTiVal + ' per ABOA SF over the FIRM term of the lease.';} }
    public String ratesQ3New { get {return '9a. Amortization Rate for Tenant Improvement Allowance (TIA) & Building Specific Amortized Capital (BSAC)';} }
    //  public String ratesQ3Succ       { get { return  '3. The annual percentage rate (APR), compounded monthly, to be used by the Lessor to amortize the cost of the Tenant Improvements plus construction markups up to $'+ usedTiVal + ' per ABOA SF over the FIRM term of the lease.';}    }
    public String ratesQ3Succ { get {return '9a. Amortization Rate for Tenant Improvement Allowance (TIA) & Building Specific Amortized Capital (BSAC)';} }
    //public String ratesQ3New_1        { get { return  '3. The annual percentage rate (APR), compounded monthly, to be used by the Lessor to amortize the cost of the Tenant Improvements up to $'+ newTiVal + ' per ABOA SF over the FIRM term of the lease.';} }
    public String ratesQ3New_1 { get {return '3. Amortization Rate for Tenant Improvement Allowance (TIA) & Building Specific Amortized Capital (BSAC)';} }
    //   public String ratesQ3Succ_1       { get { return  '3. The annual percentage rate (APR), compounded monthly, to be used by the Lessor to amortize the cost of the Tenant Improvements up to $'+ usedTiVal + ' per ABOA SF over the FIRM term of the lease.';}    }
    public String ratesQ3Succ_1 { get {return '3. Amortization Rate for Tenant Improvement Allowance (TIA) & Building Specific Amortized Capital (BSAC)';} }

//---------RITM0021675, RITM002167, RITM0021677----------------------------------------------->                            
//    Added 
    //public String ratesQBSACRateNew        { get { return  '4. The APR, compounded monthly, to be used by the Lessor to amoritize the cost of the Building Specific Amoritized Capital (BSAC) up to $' + BSAC_per_ABOAVal + ' per ABOA SF over the FIRM term of the lease.';} }
    public String ratesQBSACRateNew { get {return '4. Building Specific Amortized Capital Amortization (BSAC) Rate';} }
    public String ratesQBSACRateSucc { get {return '4. The APR, compounded monthly, to be used by the Lessor to amoritize the cost of the Building Specific Amoritized Capital (BSAC) up to $' + BSAC_per_ABOAVal + ' per ABOA SF over the FIRM term of the lease.';} }
    //   public String ratesQBSACPmtNew        { get { return  '4a. The annual amortized cost of the Building Specific Amoritized Capital (BSAC) of $'+BSAC_per_ABOAVal+' per ABOA SF. Such amortization is to be compounded monthly over the FIRM term of the lease.';} }
    public String ratesQBSACPmtNew { get {return '9d. BSAC Rent using the amount from #6.';}}// + BSAC_per_ABOAVal;} }
    public String ratesQBSACPmtSucc { get {return '9d. BSAC Rent using the amount from #6.';}}// + BSAC_per_ABOAVal_continuing_space;} }


//        public String ratesQ4New        { get { return  '4. The annual cost to amortize the Tenant Improvements allowance of $'+ newTiVal + ' per ABOA. Such amortization is to be compounded monthly over the INITIAL term of the lease.';}    }
//      Changed the label to from #4 to 3a, so if we're searching for question 3a, look for 4 instead
    //  public String ratesQ4New        { get { return  '3a. The annual cost to amortize the Tenant Improvements allowance of $'+ newTiVal + ' per ABOA SF. Such amortization is to be compounded monthly over the FIRM term of the lease.';}    } //INITIAL replaced by FIRM : Vaishali RLP FY15
    public String ratesQ4New { get {return '9c. TI Rent using the amount from #6.';} }// + newTiVal;} } //INITIAL replaced by FIRM : Vaishali RLP FY15
//---------RITM0021675, RITM002167, RITM0021677----------------------------------------------->                            

//        public String ratesQ4Succ       { get { return  '4. The annual cost to amortize the Tenant Improvements allowance of $'+ usedTiVal + ' per ABOA. Such amortization is to be compounded monthly over the INITIAL term of the lease.';}   }
// 04/05/2013 should be 3a instead of 4
    //      public String ratesQ4Succ       { get { return  '3a. The annual cost to amortize the Tenant Improvements allowance of $'+ usedTiVal + ' per ABOA SF. Such amortization is to be compounded monthly over the FIRM term of the lease.';}   }
    public String ratesQ4Succ { get {return '9c. TI Rent using the amount from #6.';} }// + usedTiVal;} }

    //  public String ratesQ5New        { get { return  '5. The fully serviced lease rate for the FIRM term per ABOA SF, including a $'+ newTiVal + ' per ABOA SF Tenant Improvement allowance.';}    }
    public String ratesQ5New { get {return '10. Fully Serviced Rent';} }
    //public String ratesQ5Succ       { get { return  '5. The fully serviced lease rate for the FIRM term per ABOA SF, including a $'+ usedTiVal + ' per ABOA SF Tenant Improvement allowance.';}   }
    public String ratesQ5Succ { get {return '10. Fully Serviced Rent';} }

    //Vaishali RLP FY15        public String ratesQ6       { get { return  '6. Option Term';}  }
    public String ratesQ6 { get {return Q6Text;} }
    //5. Fully Serviced Rent
    public String ratesQ7New { get {return '7. The APR, compounded monthly, to be used by the Lessor to amortize the cost of the Tenant Improvements plus construction markups above $' + newTiVal + ' per ABOA SF over the FIRM term of the lease, up to $' + maxTiVal + ' per ABOA SF.';} } //INITIAL replaced by FIRM : Vaishali eFix May
    //   public String ratesQ7New        { get { return  'The APR, compounded monthly, to be used by the Lessor to amortize the cost of the Tenant Improvements plus construction markups above $'+ newTiVal + ' per ABOA SF over the FIRM term of the lease, up to $' + maxTiVal + ' per ABOA SF.';}   } //INITIAL replaced by FIRM : Vaishali eFix May
    public String ratesQ7Succ { get {return '7. The APR, compounded monthly, to be used by the Lessor to amortize the cost of the Tenant Improvements plus construction markups above $' + usedTiVal + ' per ABOA SF over the FIRM term of the lease, up to $' + maxTiVal + ' per ABOA SF.';} } //INITIAL replaced by FIRM : Vaishali eFix May
    //     public String ratesQ7Succ       { get { return  '5. Fully Serviced Rent';}  } //INITIAL replaced by FIRM : Vaishali eFix May
    //6. Shell Rent (NON-FIRM Term)
    //   public String ratesQ8       { get { return  '7. The overtime rate for heating and cooling beyond normal hours specified in RLP.';}  }
    public String ratesQ8 { get {return '12. HVAC Overtime Rate';} }
    //  public String ratesQ8_7       { get { return  '7. The overtime rate for heating and cooling beyond normal hours specified in RLP.';}  }
    public String ratesQ8_7 { get {return '12. HVAC Overtime Rate';} }
    public String ratesQ9 { get {return '9. The additional amount per ABOA SF for Daytime Cleaning.';} }
    //
    ///   public String ratesQ10      { get {return '8. Number of months of free rent being offered to the Government at the start of the firm term.';}}
    public String ratesQ10 { get {return '13. Free rent in months';} }
    public String ratesQ10_8 { get {return '13. Free rent in months';} }

    public String ratesQ10New { get {return '9. The number of months of free rent without any payment of base rent, operating expenses, or amortization of $' + newTiVal + ' per ABOA SF of FIRM term Tenant Improvements plus construction markups.';} }    //INITIAL replaced by FIRM : Vaishali eFix May
    public String ratesQ10Succ { get {return '9. The number of months of free rent without any payment of base rent, operating expenses, or amortization of $' + usedTiVal + ' per ABOA SF of FIRM term Tenant Improvements plus construction markups.';} }//INITIAL replaced by FIRM : Vaishali eFix May
    public String ratesQ10a { get {return '    a. Free Rent Firm Term (in months)';} }
    public String ratesQ10b { get {return 'b. Free Rent Option Term (in months)';} }
    //Vaishali 12/17/2013
    //       public String ratesQ11New       { get { return  '10. The cooperating brokerage commission available to the Government\'s representative, as a percentage of the full-service rents (including amortization of $'+ newTiVal + ' of T.I.) to be paid over the Firm Term.';}   }
    //       public String ratesQ11Succ      { get { return  '10. The cooperating brokerage commission available to the Government\'s representative, as a percentage of the full-service rents (including amortization of $'+ usedTiVal + ' of T.I.) to be paid over the Firm Term.';}  }
    public String ratesQ11New { get {return '10. The free rent available to the Government, as a percentage of the full-service rents (including amortization of a $' + newTiVal + ' per ABOA SF of Tenant Improvement allowance) to be paid over the Firm Term.';} }
    public String ratesQ11Succ { get {return '10. The free rent available to the Government, as a percentage of the full-service rents (including amortization of a $' + usedTiVal + ' per ABOA SF of Tenant Improvement allowance) to be paid over the Firm Term.';} }
// End
    public String ratesQ12 { get {return '12. Do you have another space to add? If no, click the "Continue " button below.';} }
    //       public String ratesCol1     { get { return  '5 Year Firm Term Lease';}    }
    public String ratesCol1 { get {return col1Header;} }
    public String covidRatesCol1 { get {return '10 Year Lease (with termination rights after 5 years)';} }
// Vaishali RLP FY 15      public String ratesCol2     { get { return  '5+5 Year Lease';}  }
    public String ratesCol2 { get {return col2Header;} }
//Vaishali RLP FY15
    public String ratesCol3 { get {return '10 Year Lease (with termination rights after 8 years)';} }
    public Integer rlpFY;
// Vaishali RLP FY14
//      public String notation      { get { return  'Note: The percentages entered into the profit and overhead fields below (questions 6 through 9) will be applied against the tenant improvement fund requirement of each request and will be treated as amortized tenant improvements in the net present value calculation for evaluation purposes only. For the purposes of initial evaluation, new leases shall use $'+ newTiVal + ' per ABOA and succeeding leases shall use $' + usedTiVal + ' per ABOA.';} }
// Vaishali RLP FY15 Succeeding changed to'continuing need'
    //public String notation { get {return 'Note: The fees entered in questions 4 and 5 (below) will be applied against the tenant improvement allowance (TIA). Note that the calculation visible to offerors is based on an estimated placeholder TIA of $' + newTiVal + ' per ABOA SF, but for evaluation purposes and for the resulting lease contract, the calculation will be based on the actual TIA for the specific requirement. For additional information on the evaluation of offers, reference section 4 of the RLP.';} }
    //public String notationSucc { get {return 'Note: The fees entered in questions 4 and 5 (below) will be applied against the tenant improvement allowance (TIA). Note that the calculation visible to offerors is based on an estimated placeholder TIA of $' + usedTiVal + ' per ABOA SF, but for evaluation purposes and for the resulting lease contract, the calculation will be based on the actual TIA for the specific requirement. For additional information on the evaluation of offers, reference section 4 of the RLP.';} }
    public String notation { get {return 'The mark-up fees entered in questions #15 and #16 (below) will be applied against the tenant improvement allowance (TIA) - see item #6, above.';} }
    public String notationSucc { get {return 'The mark-up fees entered in questions #15 and #16 (below) will be applied against the tenant improvement allowance (TIA) - see item #6, above.';} }
// Vaishali RLP FY14

    /*  Operating Costs Question Labels */
    //01/21/2015 Vaishali public String opCostsQ1     { get { return  '1. Total Rentable Area SF';}   }
    public String opCostsQ1 { get {return '1. Total Building Rentable Area square feet (RSF)';} }
    //01/21/2015 Vaishali public String opCostsQ2     { get { return  '2. Total Building ABOA';}  }
    //09/13 Ramya reworded public String opCostsQ2 { get {return '2. Total Building ANSI/BOMA Office Area (ABOA) square feet (SF)';} }
    public String opCostsQ2 { get {return '2. Total Building ANSI/BOMA Occupant Area (ABOA) square feet (SF)';} }
    public String opCostsQ3 { get {return '3. Common Area Factor';} }
    //01/21/2015 Vaishali public String opCostsQ4     { get { return  '4. Cost per ABOA';}    }
    //Weston added new census verbiage:
    public String CensusopCostQ4 { get {return '4. Operating Costs per ABOA SF';} }
    public String opCostsQ4 { get {return '4. Cost per ABOA SF';} }
    public String opCostsQ5 { get {return '5. Salaries';} }
    public String opCostsQ6 { get {return '6. Supplies (wax, cleaners, cloths, etc.)';} }
    public String opCostsQ7 { get {return '7. Contract Services (windows washing, waste and snow removal)';} }
    public String opCostsQ8 { get {return '8. Salaries';} }
    public String opCostsQ9 { get {return '9. Fuel';} }
    public String opCostsQ10 { get {return '10. System Maintenance and Repair';} }
    public String opCostsQ11 { get {return '11. Current for Light and Power';} }
    public String opCostsQ12 { get {return '12. Replacement of Bulbs, Tubes, Starters';} }
    public String opCostsQ13 { get {return '13. Power for Special Equipment';} }
    public String opCostsQ14 { get {return '14. System maintenance and repair (ballasts, fixtures, etc.)';} }
    public String opCostsQ15 { get {return '15. Water (for all purposes, include sewage charges)';} }
    public String opCostsQ16 { get {return '16. Supplies (Soap, towels, tissues not in 6 above)';} }
    public String opCostsQ17 { get {return '17. System Maintenance and Repair';} }
    public String opCostsQ18 { get {return '18. Utilities (Include electricity, if not in C11)';} }
    public String opCostsQ19 { get {return '19. System Maintenance and Repair';} }
    public String opCostsQ20 { get {return '20. Salaries (operators, starters, etc.)';} }
    public String opCostsQ21 { get {return '21. System Maintenance and Repair';} }
    public String opCostsQ22 { get {return '22. Building Engineer and/or Manager';} }
    public String opCostsQ23 { get {return '23. Security (Watchperson, guards, not janitors)';} }
    public String opCostsQ24 { get {return '24. Social Security Tax and Workperson\'s Compensation Insurance';} }
    public String opCostsQ25 { get {return '25. Lawn and Landscaping Maintenance';} }
    public String opCostsQ26 { get {return '26. Other';} }
    public String opCostsQ27 { get {return '27. Total';} }
    public String opCostsQ28 { get {return '28. Real Estate Taxes';} }
    public String opCostsQ29 { get {return '29. Insurance (hazard, liability, etc.)';} }
    public String opCostsQ30 { get {return '30. Building Maintenance and Reserves for Replacement';} }
    public String opCostsQ31 { get {return '31. Lease Commission';} }
    public String opCostsQ32 { get {return '32. Management';} }
    public String opCostsQ33 { get {return '33. Total';} }
    public String opCostsPgHdr { get {return 'Operating & Ownership Costs';} }
    public String opCostsSubSectOne { get {return 'A. Cleaning, Janitor and/or Char Service';} }
    public String opCostsSubSectTwo { get {return 'B. Heating';} }
    public String opCostsSubSectThree { get {return 'C. Electrical';} }
    public String opCostsSubSectFour { get {return 'D. Plumbing';} }
    public String opCostsSubSectFive { get {return 'E. Air Conditioning';} }
    public String opCostsSubSectSix { get {return 'F. Elevators';} }
    public String opCostsSubSectSeven { get {return 'G. Miscellaneous (To the extent not included above)';} }
    public String opCostsSectOneHdr { get {return 'Section I: Estimated Annual Cost of Services and Utilities Furnished By Lessor As Part of Rental Consideration - Cost for Entire Building';} }
    public String opCostsSectTwoHdr { get {return 'Section II: Estimated Annual Cost of Ownership Exclusive of Capital Charges';} }
    public String otherCostsQ1 { get {return '1. Enter a short description for the cost.';} }
    public String otherCostsQ2 { get {return '2. Enter the annual amount of the cost.';} }
    public String otherCostsTableColOne { get {return 'Short Description';} }
    public String otherCostsTableColTwo { get {return 'Cost';} }
    public String otherCostsTableColThree { get {return 'Remove';} }
    public String otherTotOtherCostTxt { get {return 'Total';} }

    public String lopOpCostsSectOneHdr { get {return 'Section I: Estimated Annual Cost of Services and Utilities Furnished By Lessor As Part of Rental Consideration';} }
    public String lopOpCostCol1 { get {return 'For Entire Building';} }
    public String lopOpCostCol2 { get {return 'For Government Leased Areas';} }
    public String lopOpCostsQ5 { get {return '1. Salaries';} }
    public String lopOpCostsQ6 { get {return '2. Supplies (wax, cleaners, cloths, etc.)';} }
    public String lopOpCostsQ7 { get {return '3. Contract Services (windows washing, waste and snow removal)';} }
    public String lopOpCostsQ8 { get {return '4. Salaries';} }
    public String lopOpCostsQ9 { get {return '5. Fuel';} }
    public String lopOpCostsQ10 { get {return '6. System Maintenance and Repair';} }
    public String lopOpCostsQ11 { get {return '7. Current for Light and Power';} }
    public String lopOpCostsQ12 { get {return '8. Replacement of Bulbs, Tubes, Starters';} }
    public String lopOpCostsQ13 { get {return '9. Power for Special Equipment';} }
    public String lopOpCostsQ14 { get {return '10. System maintenance and repair (ballasts, fixtures, etc.)';} }
    public String lopOpCostsQ15 { get {return '11. Water (for all purposes, include sewage charges)';} }
    public String lopOpCostsQ16 { get {return '12. Supplies (soap, towels, tissues not in A2 above)';} }
    public String lopOpCostsQ17 { get {return '13. System Maintenance and Repair';} }
    public String lopOpCostsQ18 { get {return '14. Utilities (include electricity, if not in C7 above)';} }
    public String lopOpCostsQ19 { get {return '15. System Maintenance and Repair';} }
    public String lopOpCostsQ20 { get {return '16. Salaries (operators, starters, etc.)';} }
    public String lopOpCostsQ21 { get {return '17. System Maintenance and Repair';} }
    public String lopOpCostsQ22 { get {return '18. Building Engineer and/or Manager';} }
    public String lopOpCostsQ23 { get {return '19. Security (Watchperson, guards, not janitors)';} }
    public String lopOpCostsQ24 { get {return '20. Social Security Tax and Workperson\'s Compensation Insurance';} }
    public String lopOpCostsQ25 { get {return '21. Lawn and Landscaping Maintenance';} }
    public String lopOpCostsQ26 { get {return '22. Other';} }
    public String lopOpCostsQ27 { get {return '23. Total';} }
    public String lopOpCostsQ28 { get {return '24. Real Estate Taxes';} }
    public String lopOpCostsQ29 { get {return '25. Insurance (hazard, liability, etc.)';} }
    public String lopOpCostsQ30 { get {return '26. Building Maintenance and Reserves for Replacement';} }
    public String lopOpCostsQ31 { get {return '27. Lease Commission';} }
    public String lopOpCostsQ32 { get {return '28. Management';} }
    public String lopOpCostsQ33 { get {return '29. Total';} }

    //lop space and rates
    public String lopSpaceQ1 { get {return '1. What is the amount of ANSI/BOMA Office Area Square Feet (ABOA SF) offered? ';} }
    public String lopSpaceQ2 { get {return '2. What is the amount of Rentable Square Feet (RSF) offered? ';} }
    public String lopSpaceQ3 { get {return '3. Common Area Factor (CAF):';} }
    public String lopSpaceQ2a { get {return '2a. Is the offered space located on more than one floor? ';} }
    public String lopSpaceQ4 { get {return '5. Percent of Government Occupancy: ';} }
    public String lopSpaceQ5 { get {return 'Does annual Rent include Parking? ';} }
    public String lopSpaceQ6 { get {return '1. If you are offering free rent, enter the number of months free you are offering. If you are not offering free rent, leave the field blank or &nbsp;&nbsp;&nbsp;&nbsp;enter ‘0’.';} }
    public String lopSpaceQ7 { get {return 'Must be completed when the RLP requires a renewal option.  If not required, offerors may elect to propose renewal terms for the Government\'s consideration. ';} }
    public String lopSpaceQ8 { get {return '1. Enter the renewal option Shell Rate: ';} }
    public String lopSpaceQ9 { get {return '2. Enter the number of years for each renewal option';} }
    public String lopSpaceQ10 { get {return '3. Enter the number of Renewal Options:';} }
    public String lopSpaceQ11 { get {return '4. Enter the number of days notice to exercise Renewal Options:';} }
    public String lopSpaceQ12 { get {return 'Are there step rents as a part of the offer?';} }


    //public String lopSpaceQ5    { get { return  '2. What is the amount of Rentable Square Feet (RSF) offered? ';}   }

    /*  Constructors    */
    public PBS_AAAP_QuestionLabels(String pId) {

        System.debug('##### QUEST LABEL: pId = ' + pId);
        PBS_AAAP_RLP__c rlp = dao.getRLP(pId);
        //added by syam on 12/28/2016 for null pointer check
        this.maxTiVal = rlp.PBS_AAAP_MAX_TIUSED__c == null ? '0.00' : rlp.PBS_AAAP_MAX_TIUSED__c.setScale(2).format();
        system.debug('PBS_AAAP_QuestionLabels constructor 1 ==' + rlp.PBS_AAAP_MAX_TIUSED__c);

        this.newTiVal = rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c == null ? '0.00' : rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c.setScale(2).format();
        system.debug('PBS_AAAP_QuestionLabels constructor 2 ==' + rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c + ' == ' + this.newTiVal);
        decimal newTiValDecimal = Decimal.valueOf(this.newTiVal.replaceAll(',', ''));
        system.debug('PBS_AAAP_QuestionLabels constructor 2a ==' + newTiValDecimal);
        newTiValDecimal = newTiValDecimal.setScale(2);
        system.debug('PBS_AAAP_QuestionLabels constructor 2b ==' + newTiValDecimal);
        this.newTiVal = String.valueOf(newTiValDecimal);
       

        this.usedTiVal = rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c == null ? '0.00' : rlp.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c.setScale(2).format();
        decimal usedTiValDecimal = Decimal.valueOf(this.usedTiVal.replaceAll(',', ''));
        usedTiValDecimal = usedTiValDecimal.setScale(2);
        this.usedTiVal = String.valueOf(usedTiValDecimal);

        system.debug('PBS_AAAP_QuestionLabels constructor 3');

// RLP FY15 O&M1           this.col2Header  =  (rlp.PBS_AAAP_Allow_10_5_Term__c)? '10 Year Lease, 5 Firm':'5+5 Year Lease';
        rlpFY = Integer.valueOf(rlp.PBS_AAAP_Year__c);
        //this.col2Header = (rlp.PBS_AAAP_Allow_10_5_Term__c) ? '10 Year Lease (with termination rights after 5 years)' : '5+5 Year Lease';
        this.col2Header = '15 Year Lease (with termination rights after 13 years)';
        this.col1Header = (rlpFY > 2016) ? '17 Year Lease (with termination rights after 15 years)' : '5 Year Lease';
//Vaishali changed question for FY17 next line  6. Shell Rent (NON-FIRM Term)
        //this.Q6Text=(rlp.PBS_AAAP_Allow_10_5_Term__c)?'6. Enter Shell Rate per ANSI/BOMA Office Area (ABOA) square foot (SF) for years 6-10 / years 11-15.  If Shell Rate is unchanged from years 1-5 (or years 1-10), enter Shell Rate amount from #1 above.':'6. Option Term';
        this.Q6Text = '11. Shell Rent (Yr 9 to end of Lease)';
        this.BSAC_per_ABOAVal = (rlp.PBS_AAAP_BSAC_per_ABOA__c == null) ? '0.00' : rlp.PBS_AAAP_BSAC_per_ABOA__c.setScale(2).toPlainString() ;
        this.BSAC_per_ABOAVal_continuing_space = (rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c == null) ? '0.00' : rlp.BSAC_for_Continuing_Space_per_ABOA_SF__c.setScale(2).toPlainString() ;


    }   // end constructor

    public PBS_AAAP_QuestionLabels() {

    }

}
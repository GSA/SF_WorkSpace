window.myHTML =   
     '<p><h5><b>USER INSTRUCTIONS:</b></h5><br><ul class="slds-list_dotted"><li>User MUST input WI Code (See below for explanation). User MUST input the line item Description, Quantity, and Unit Cost in order for the Totals to be calculated.</li><li>Inputting the WI Code allows the tool to automatically sum the Direct Costs, CECA, ECCA, and ECC by Work Item Code.</b></li><br></ul></p>' +   
	 '<table style="width:75%" class="slds-table slds-table_cell-buffer slds-table_bordered slds-table_striped slds-table--fixed-layout" >'+
  '<thead>' +
    '<tr class="slds-line-height_reset">' +
      '<th class="" scope="col" width="10%">' +
        '<div class="slds-truncate" title="WICodeNum">WI Code #</div>' +
      '</th>' +
      '<th class="" scope="col" width="75%">' +
        '<div class="slds-truncate" title="WICodeDesc">WI Code Description</div>' +
      '</th>' +
      '</tr>' +
  '</thead>' +
  '<tbody>' +
    '<tr class="slds-hint-parent">' +
      '<td data-label="item1">' +
        '<div class="slds-truncate">' +
          '1' +
        '</div>' +
      '</td>' +
      '<td data-label="item1desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>Entry Lobby Upgrades/Restoration (Monumental):</b> The entry lobby area is defined as all public area connecting primary entry into the building to the front door of areas assigned to tenants and the primary vertical circulation system. Include costs for all the refinishing of existing stonework, terrazzo, and other wall or ceiling finishes.'+
		'</div>' +
      '</td>' +
    '</tr>' +
	'<tr class="slds-hint-parent">' +
      '<td data-label="item2">' +
        '<div class="slds-truncate">' +
          '2' +
        '</div>' +
      '</td>' +
      '<td data-label="item2desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>Secondary Public Lobbies & Circulation (non-monumental):</b> Secondary public lobbies and circulation is defined as the area between primary non-monumental vertical circulation systems and the assigned tenant areas.'+
		'</div>' +
      '</td>' +
    '</tr>' +
		'<tr class="slds-hint-parent">' +
      '<td data-label="item3">' +
        '<div class="slds-truncate">' +
          '3' +
        '</div>' +
      '</td>' +
      '<td data-label="item3desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>Restroom Upgrades:</b> Includes new fixtures, modifications to  address ADA requirements, upgrades to floor, wall, and ceiling finishes. Provide number restrooms and the number of plumbing fixture units/restrooms being updated.' +
		'</div>' +
      '</td>' +
    '</tr>' +
		'<tr class="slds-hint-parent">' +
      '<td data-label="item4">' +
        '<div class="slds-truncate">' +
          '4' +
        '</div>' +
      '</td>' +
      '<td data-label="item4desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>Demolition/ Core Shell Prep:</b> This cost element is to remove existing interior improvements and prepare areas to receive interior tenant-fit-out type sapce alternations. Pursuant to the PBS Pricing Policy, this cost is charged against the shell budget for major R&A projects unless the project was specifically requested by the tenant post-initial occupancy. It includes demolition and disposal of existing interior walls, ceilings, and floor finishes.' +
		'</div>' +
      '</td>' +
    '</tr>' +
		'<tr class="slds-hint-parent">' +
      '<td data-label="item5">' +
        '<div class="slds-truncate">' +
          '5' +
        '</div>' +
      '</td>' +
      '<td data-label="item5desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>Interior Build-Out/Completion - Building Core/Shell:</b> This cost element is to include the build-out cost of all interior spaces shared by multiple tenants. Examples of these are shared Conference Rooms, Cafeteria, Auditoriums, etc.' +
		'</div>' +
      '</td>' +
    '</tr>' +
		'<tr class="slds-hint-parent">' +
      '<td data-label="item6">' +
        '<div class="slds-truncate">' +
          '6' +
        '</div>' +
      '</td>' +
      '<td data-label="item6desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>Tenant Fit-Out Cost:</b> Tenant fit-out costs follow the definition of GSA\'s Pricing structure. Includes all interior work within a tenant space assignment. Includes ancillary work to other systems due to the tenant fit-out/upgrades from warm-lit shell. Includes any Raised Flooring required in tenant space. Provide overall floor area being built out.'+
		'</div>' +
      '</td>' +
    '</tr>' +
		'<tr class="slds-hint-parent">' +
      '<td data-label="item7">' +
        '<div class="slds-truncate">' +
          '7 <br>i.e. A2, B2, etc.' +
        '</div>' +
      '</td>' +
      '<td data-label="item7desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>Security/Blast:</b> [May be all of window and structural work] Upgrades to structure and exterior enclosure to provide for blast, glass fragmentation, or progressive collapse.'+
		'</div>' +
      '</td>' +
    '</tr>' +
		'<tr class="slds-hint-parent">' +
      '<td data-label="item2">' +
        '<div class="slds-truncate">' +
          '8 <br>i.e. A3, B3, <br>C3, etc.' +
        '</div>' +
      '</td>' +
      '<td data-label="item2desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>RWA-Funded Work:</b> Work Item 8 covers the cost of all tenant work that is intended to be funded by the tenant agency. In particular any agency-specific elements of work not typically considered in a space fit-out. If the estimated costs for a tenant space fit-out is greater than the agency tier allowance, the cost above and beyond the tier allowance will be required to be funded by RWA, but not coded as an RWA Item in the ASTM Uniformat Detail. In cases where the TI Fit-Out Cost for any specifc agency is greater than the agency tier allowance, the difference is reported to the "Agency RWA Cost Sum Report" and the "CEW Output Report", as well as the "Work Item Report", even though the user doesn\'t specifically code the line item as an RWA-funded work.'+
		'</div>' +
      '</td>' +
    '</tr>' +
		'<tr class="slds-hint-parent">' +
      '<td data-label="item9">' +
        '<div class="slds-truncate">' +
          '9' +
        '</div>' +
      '</td>' +
      '<td data-label="item9desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>Special Requirements: </b> [List large items separately] Agency or site requirements such as tunnels, antenna'+
		'</div>' +
      '</td>' +
    '</tr>' +
		'<tr class="slds-hint-parent">' +
      '<td data-label="item10">' +
        '<div class="slds-truncate">' +
          '10' +
        '</div>' +
      '</td>' +
      '<td data-label="item10desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>New Construction Additions: </b> such as building in fills or small additions. This item is generally benchmarked using the CTHSE cost Benchmark Tool for Court Projects, or the National Cost Management Toolbox (NCMT) for all other project types and costs loaded herein when the project is generally a R&A project.'+
		'</div>' +
      '</td>' +
    '</tr>' +
		'<tr class="slds-hint-parent">' +
      '<td data-label="item11">' +
        '<div class="slds-truncate">' +
          '11' +
        '</div>' +
      '</td>' +
      '<td data-label="item11desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>Building Structure: </b> Includes all cost (Architectural, Structural, Mechanical, and Electrical) necessary for the execution of work associated with bringing the building up to current-day seismic, hurricane, or other structural standards, apart from the blast, glass fragmentation and progressive collapse noted above.'+
		'</div>' +
      '</td>' +
    '</tr>' +
		'<tr class="slds-hint-parent">' +
      '<td data-label="item12">' +
        '<div class="slds-truncate">' +
          '12' +
        '</div>' +
      '</td>' +
      '<td data-label="item12desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>Building Exterior: </b> Includes all cost (Architectural, Structural, Mechanical, and Electrical) necessary for the execution of work associated with maintenance, repair, and/or replacement or exterior closure system elements, including stonework, masonry, glazing, curtainwalls, storefronts, ext. doors, etc.'+
		'</div>' +
      '</td>' +
    '</tr>' +
		'<tr class="slds-hint-parent">' +
      '<td data-label="item13">' +
        '<div class="slds-truncate">' +
          '13' +
        '</div>' +
      '</td>' +
      '<td data-label="item13desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>Roofing: </b> Includes work associated repair, maintenance, and/or replacement of roof system, and all ancillary subcomponents. Other systems costs that are incurred because of a roofing work item is executed will be included in the cost of the roofing work item. An example could be the removal and reseting of roof drains.</'+
		'</div>' +
      '</td>' +
    '</tr>' +
		'<tr class="slds-hint-parent">' +
      '<td data-label="item14">' +
        '<div class="slds-truncate">' +
          '14' +
        '</div>' +
      '</td>' +
      '<td data-label="item14desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>Conveying System: </b> Includes the cost for repair and replacement of all public conveying system. Includes all architectural, mechanical and electrical costs incurred because of the execution of conveying system work item.'+
		'</div>' +
      '</td>' +
    '</tr>' +
		'<tr class="slds-hint-parent">' +
      '<td data-label="item15">' +
        '<div class="slds-truncate">' +
          '15' +
        '</div>' +
      '</td>' +
      '<td data-label="item15desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>Plumbing: </b> Includes all costs associated with the Domestic Water, Sanitary Waste and all roof drainage not associated with a roof replacement work item. Also includes plumbing fixtures not associated with restroom renovation, lobby renovation, or circulation space renovation. Also includes all other system cost associated with plumbing retrofit costs.'+
		'</div>' +
      '</td>' +
    '</tr>' +
		'<tr class="slds-hint-parent">' +
      '<td data-label="item16">' +
        '<div class="slds-truncate">' +
          '16' +
        '</div>' +
      '</td>' +
      '<td data-label="item16desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>HVAC: </b> Includes major items such as chiller, cooling tower, and boiler repair, replacement, or new installation. Includes air distribution system repair and/or replacement, including main AHU\'s, ductwork trunk and secondary lines to branch lines feeding supply and return diffusers.'+
		'</div>' +
      '</td>' +
    '</tr>' +
		'<tr class="slds-hint-parent">' +
      '<td data-label="item17">' +
        '<div class="slds-truncate">' +
          '17' +
        '</div>' +
      '</td>' +
      '<td data-label="item17desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>Electrical: </b> Includes major items such as switch gear, transformers, meters, cable, distribution panels, bus duct, panelboards, conduit, fittings, etc., to support all electrical systems. The replacement of the lighting system will be included in either the "Core-Shell" work item, or the tenant fit-out work item, whichever is appropriate in keeping with the limits of the pricing policy.'+
		'</div>' +
      '</td>' +
    '</tr>' +
		'<tr class="slds-hint-parent">' +
      '<td data-label="item18">' +
        '<div class="slds-truncate">' +
          '18' +
        '</div>' +
      '</td>' +
      '<td data-label="item18desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>Life Safety: </b> Includes major components to the central fire alarm system, fire protection system, egress components, etc. Note: Fire alarm wiring from building core to tenant space and then within tenant space; pull stations; strobes; annunciators; and, exit signage within the demised premises shall be considered a part of the TI costs.'+
		'</div>' +
      '</td>' +
    '</tr>' +
		'<tr class="slds-hint-parent">' +
      '<td data-label="item19">' +
        '<div class="slds-truncate">' +
          '19' +
        '</div>' +
      '</td>' +
      '<td data-label="item19desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>Hazardous Abatement: </b> Includes Asbestos Abatement, Mold Mitigation, Lead Paint Abatement or other work performed related to mitigation of hazardous materials concerns in a facility, or on a site.'+
		'</div>' +
      '</td>' +
    '</tr>' +
		'<tr class="slds-hint-parent">' +
      '<td data-label="item20">' +
        '<div class="slds-truncate">' +
          '20' +
        '</div>' +
      '</td>' +
      '<td data-label="item20desc">' +
        '<div class="slds-cell-wrap">'+
		'<b>Grounds and Approaches: </b> Includes work on site and area surrounding building, including walkways, streets, drives, parking, landscape, exterior stairs and other work external to the building(s)'+
		'</div>' +
      '</td>' +
    '</tr>' +
	  '</tbody>' +
'</table>';
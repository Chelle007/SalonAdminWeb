<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
        <meta charset="utf-8" />
        <jsp:include page="title.jsp" flush="true" />
        <meta
            name="description"
            content="Dynamic tables and grids using jqGrid plugin"
        />
        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0, maximum-scale=1.0"
        />

        <!-- bootstrap & fontawesome -->
        <link rel="stylesheet" href="assets/css/bootstrap.min.css" />
        <link
            rel="stylesheet"
            href="assets/font-awesome/4.5.0/css/font-awesome.min.css"
        />

        <!-- page specific plugin styles -->
        <link rel="stylesheet" href="assets/css/jquery-ui.min.css" />
        <link
            rel="stylesheet"
            href="assets/css/bootstrap-datepicker3.min.css"
        />
        <link rel="stylesheet" href="assets/css/ui.jqgrid.min.css" />

        <!-- text fonts -->
        <link rel="stylesheet" href="assets/css/fonts.googleapis.com.css" />

        <!-- ace styles -->
        <link
            rel="stylesheet"
            href="assets/css/ace.min.css"
            class="ace-main-stylesheet"
            id="main-ace-style"
        />

        <!--[if lte IE 9]>
            <link
                rel="stylesheet"
                href="assets/css/ace-part2.min.css"
                class="ace-main-stylesheet"
            />
        <![endif]-->
        <link rel="stylesheet" href="assets/css/ace-skins.min.css" />
        <link rel="stylesheet" href="assets/css/ace-rtl.min.css" />

        <!--[if lte IE 9]>
            <link rel="stylesheet" href="assets/css/ace-ie.min.css" />
        <![endif]-->

        <!-- inline styles related to this page -->

        <!-- ace settings handler -->
        <script src="assets/js/ace-extra.min.js"></script>

        <!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->

        <!--[if lte IE 8]>
            <script src="assets/js/html5shiv.min.js"></script>
            <script src="assets/js/respond.min.js"></script>
        <![endif]-->
    </head>
</html>
<%
	javax.servlet.http.HttpSession ses = request.getSession();
	if (ses.getAttribute("User") == null){ //checking expired session
	System.out.println("Session expired or user not logged in");
%>
	    <jsp:include page="login.jsp" flush ="true"/>
<%
        }else{
        com.ysoft.General gen = new com.ysoft.General();
        com.ysoft.subgeneral sgen = new com.ysoft.subgeneral();
        String tp=gen.gettable(request.getParameter("tp"));
        String title=gen.gettable(request.getParameter("title"));
 	    com.ysoft.convertxml convert = new com.ysoft.convertxml();
  		com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
      	java.sql.Connection conn = connMgr.getConnection("db2");
        java.io.PrintWriter log = new java.io.PrintWriter(new java.io.FileWriter(gen.getDataLogFileQuery(), true), true);
      	com.ysoft.subgeneral queryclass = new com.ysoft.subgeneral();

        String[] judul = null;
        String prefix = "";
        // ubah sini
        if ("P_EMPLOYEE".equals(tp)) {
            judul = new String[]{"ID", "E_ID", "Name", "Manage_level", "Address", "Contact_no", "Join_date", "Resign_date", "Salary_percentage", "Salary_amount", "Salary_type"};
            prefix = "E";
        } else if ("P_MEMBER".equals(tp)) {
            judul = new String[]{"ID", "M_ID", "Name", "Category", "Address", "Contact_no"};
            prefix = "M";
        } else if ("P_SUPPLIER".equals(tp)) {
            judul = new String[]{"ID", "SU_ID", "Name", "Address", "Contact_no", "Payment_grace_period"};
            prefix = "SU";
        } else if ("P_AGENT".equals(tp)) {
            judul = new String[]{"ID", "A_ID", "Name", "Address", "Contact_no", "Agent_fee_percentage"};
            prefix = "A";
        } else if ("S_BANK".equals(tp)) {
            judul = new String[]{"ID", "BA_ID", "Bank_name", "Bank_account", "Bank_account_name"};
            prefix = "BA";
        } else if ("S_ITEM".equals(tp)) {
            judul = new String[]{"ID", "I_ID", "Item_desc", "Cat", "Qty", "Unit_type", "Report_unit", "Volume_per_unit", "Purchase", "Sales_1", "Sales_2", "Sales_3", "Sales_4", "Min_stock"};
            prefix = "I";
        }
        String msg = "";
        if (gen.gettable(request.getParameter("act")).equalsIgnoreCase("save")) {
            if (gen.gettable(request.getParameter("oper")).equalsIgnoreCase("del")) {
                String ID = "";
                java.util.Vector d = (java.util.Vector) ses.getAttribute("data");
                for (int m = 0; m < d.size(); m += judul.length) {
                    if (gen.getInt(request.getParameter("id")) == (m / judul.length + 1)) {
                        ID = gen.gettable(d.get(m + 1)).trim();
                        break;
                    }
                }
                msg = sgen.update(conn, tp + "DELETE", new String[]{ID});
                msg = sgen.update(conn, "LOGMENUPARMADD", new String[]{gen.gettable(ses.getAttribute("User")), tp + "DELETE", ID});
            } else if (gen.gettable(request.getParameter("oper")).equalsIgnoreCase("edit")) {
                java.util.Vector d = (java.util.Vector) ses.getAttribute("data");
                boolean add=true;
                if(gen.gettable(request.getParameter(judul[1])).length()>0){
                    java.util.Vector exist = sgen.getDataQuery(conn, tp + "_EXIST", new String[]{gen.gettable(request.getParameter(judul[1]))});
                    if(exist.size()>0){//update mode
                        add=false;
                    }
                }
                if(!add){
                    String[] updateArray = new String[judul.length - 1];
                    for (int i = 2; i < judul.length; i++) {
                        updateArray[i - 2] = gen.gettable(request.getParameter(judul[i]));
                    }
                    updateArray[judul.length - 2] = gen.gettable(request.getParameter(judul[1]));
                    if ("P_EMPLOYEE".equals(tp)) {
                        if(updateArray[4].indexOf('/')>0){
                           updateArray[4]= sgen.ConvertDateFormat("mm/dd/yyyy","dd-mm-yyyy",updateArray[4]);
                        }
                        if(updateArray[5].indexOf('/')>0){
                           updateArray[5]= sgen.ConvertDateFormat("mm/dd/yyyy","dd-mm-yyyy",updateArray[5]);
                        }
                    }
                    msg = sgen.update(conn, tp + "UPDATE", updateArray);
                    msg = sgen.update(conn, "LOGMENUPARMADD", new String[]{gen.gettable(ses.getAttribute("User")), tp + "UPDATE", gen.gettable(request.getParameter(judul[1]))});
                } else {//add mode
                    String ID = "";
                    java.util.Vector membx = sgen.getDataQuery(conn, tp + "MAXID", new String[0]);
                    if (membx.size() > 0) {
                        String p = gen.gettable(membx.get(0)).trim().substring(prefix.length());
                        int nextNumber = gen.getInt(p) + 1;
                        ID = prefix + String.format("%03d", nextNumber);
                    } else {
                        ID = prefix + "001";
                    }
                    String[] addArray = new String[judul.length - 1];
                    addArray[0] = ID;
                    for (int i = 1; i < addArray.length; i++) {
                        addArray[i] = gen.gettable(request.getParameter(judul[i+1]));
                    }
                    if ("P_EMPLOYEE".equals(tp)) {
                        if(addArray[5].indexOf('/')>0){
                           addArray[5]= sgen.ConvertDateFormat("mm/dd/yyyy","dd-mm-yyyy",addArray[5]);
                        }
                        if(addArray[6].indexOf('/')>0){
                           addArray[6]= sgen.ConvertDateFormat("mm/dd/yyyy","dd-mm-yyyy",addArray[6]);
                        }
                    }
                    msg = sgen.update(conn, tp + "ADD", addArray);
                    msg = sgen.update(conn, "LOGMENUPARMADD", new String[]{gen.gettable(ses.getAttribute("User")), tp + "ADD", ID});
                }
            }else{
	 /*   java.util.Enumeration enu = request.getParameterNames();
 	    while (enu.hasMoreElements()){
   		 	String pr =gen.gettable(enu.nextElement());
             System.out.println(pr+"="+request.getParameter(pr));
        }*/
                    String ID = "";
                    java.util.Vector membx = sgen.getDataQuery(conn, tp + "MAXID", new String[0]);
                    if (membx.size() > 0) {
                        String p = gen.gettable(membx.get(0)).trim().substring(prefix.length());
                        int nextNumber = gen.getInt(p) + 1;
                        ID = prefix + String.format("%03d", nextNumber);
                    } else {
                        ID = prefix + "001";
                    }
                    String[] addArray = new String[judul.length - 1];
                    addArray[0] = ID;
                    for (int i = 1; i < addArray.length; i++) {
                        addArray[i] = gen.gettable(request.getParameter(judul[i+1]));
                    }
                   
                    if ("P_EMPLOYEE".equals(tp)) {
                        if(addArray[5].indexOf('/')>0){
                           addArray[5]= sgen.ConvertDateFormat("mm/dd/yyyy","dd-mm-yyyy",addArray[5]);
                        }
                        if(addArray[6].indexOf('/')>0){
                           addArray[6]= sgen.ConvertDateFormat("mm/dd/yyyy","dd-mm-yyyy",addArray[6]);
                        }
                    }
                    msg = sgen.update(conn, tp + "ADD", addArray);
                    msg = sgen.update(conn, "LOGMENUPARMADD", new String[]{gen.gettable(ses.getAttribute("User")), tp + "ADD", ID});
            }
        }

        String COL = "'";
        for (int i = 0; i < judul.length; i++) {
            COL += judul[i];
            if (i < judul.length - 1) {
                COL += "','";
            }
        }
        COL += "'";
        java.util.Vector data=sgen.getDataQuery(conn,tp,new String[0]);
 /*       for(int ss=0;ss<judul.length*5;ss++){
            data.addElement("");
        }
   */     int hitx=1;
        for(int s=0;s<data.size();s+=judul.length){
            data.setElementAt(hitx+"",s);
            hitx++;
        }

        ses.setAttribute("data",data);
        if(gen.gettable(request.getParameter("tpx")).equalsIgnoreCase("Download")){
              com.ysoft.BUILDEXCEL bd=new com.ysoft.BUILDEXCEL();
              java.util.Vector judulx=gen.getElement(',',COL.replace("'", "")+",");
              ses.setAttribute("DATAXLS",data);
              ses.setAttribute("JUDULXLS",judulx);
              bd.doAll(request);
        }

        connMgr.freeConnection("db2", conn);
        connMgr.release();

%>

	<body class="no-skin"   <%if(gen.gettable(request.getParameter("tpx")).startsWith("Download")){%> onload="pop()"<%}%>>
        <jsp:include page="menu.jsp" flush ="true"/>
			<div class="main-content">
				<div class="main-content-inner">
					<div class="page-content">
						<div class="page-header">
							<h1>
								<%=title%>&nbsp;&nbsp;&nbsp;<a href="javascript:down()"><img width=30 height=30 src=image/download.jfif ></a>
							</h1>
						</div><!-- /.page-header -->
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
								<table id="grid-table"></table>

								<div id="grid-pager"></div>

								<!-- PAGE CONTENT ENDS -->
							</div><!-- /.col -->
						</div><!-- /.row -->
					</div><!-- /.page-content -->
				</div>
			</div><!-- /.main-content -->
        <jsp:include page="footer.jsp" flush ="true"/>

		<!-- basic scripts -->

		<!--[if !IE]> -->
		<script src="assets/js/jquery-2.1.4.min.js"></script>

		<!-- <![endif]-->

		<!--[if IE]>
<script src="assets/js/jquery-1.11.3.min.js"></script>
<![endif]-->
		<script type="text/javascript">
			if('ontouchstart' in document.documentElement) document.write("<script src='assets/js/jquery.mobile.custom.min.js'>"+"<"+"/script>");
		</script>
		<script src="assets/js/bootstrap.min.js"></script>

		<!-- page specific plugin scripts -->
		<script src="assets/js/bootstrap-datepicker.min.js"></script>
		<script src="assets/js/jquery.jqGrid.min.js"></script>
		<script src="assets/js/grid.locale-en.js"></script>

		<!-- ace scripts -->
		<script src="assets/js/ace-elements.min.js"></script>
		<script src="assets/js/ace.min.js"></script>

		<!-- inline scripts related to this page -->
		<script type="text/javascript">
            function  refresh(){
                     document.BGA.act.value="Filter";
                      BGA.submit();
            }
            function  xfresh(){
                     window.location.reload(true);
            }
            function down(){
                location.href="master1.jsp?tp=<%=tp%>&title=<%=title%>&tb=<%=gen.gettable(request.getParameter("tp"))%>&Y11=<%=gen.gettable(request.getParameter("tp"))%>&tpx=Download";
            }

        	function pop(){
        		window.open("download/<%=gen.gettable(request.getParameter("tp"))%>.xls","","toolbar=yes,menubar=yes,resizable=1,scrollbars=1");
        	}

			var grid_data =
			[
            <%
            int hit=1;
            for(int m=0;m<data.size();m+=judul.length){
                  String dataString = "{";
                  for (int i = 0; i<judul.length-1; i++) {
                      dataString += judul[i] + ":\"" + gen.gettable(data.get(m+i)).trim() + "\",";
                  }
                  dataString += judul[judul.length-1] + ":\"" + gen.gettable(data.get(m+(judul.length-1))).trim() + "\"}";

                  if(m==data.size()-judul.length){
                      out.println(dataString);
                  }else{
                      out.println(dataString + ",");
                  }
                hit++;
            }
            %>
			];

			var subgrid_data =
			[
			 {id:"1", name:"sub grid item 1", qty: 11},
			 {id:"2", name:"sub grid item 2", qty: 3},
			 {id:"3", name:"sub grid item 3", qty: 12},
			 {id:"4", name:"sub grid item 4", qty: 5},
			 {id:"5", name:"sub grid item 5", qty: 2},
			 {id:"6", name:"sub grid item 6", qty: 9},
			 {id:"7", name:"sub grid item 7", qty: 3},
			 {id:"8", name:"sub grid item 8", qty: 8}
			];

			jQuery(function($) {
				var grid_selector = "#grid-table";
				var pager_selector = "#grid-pager";

				var parent_column = $(grid_selector).closest('[class*="col-"]');
				//resize to fit page size
				$(window).on('resize.jqGrid', function () {
					$(grid_selector).jqGrid( 'setGridWidth', parent_column.width() );
			    })

				//resize on sidebar collapse/expand
				$(document).on('settings.ace.jqGrid' , function(ev, event_name, collapsed) {
					if( event_name === 'sidebar_collapsed' || event_name === 'main_container_fixed' ) {
						//setTimeout is for webkit only to give time for DOM changes and then redraw!!!
						setTimeout(function() {
							$(grid_selector).jqGrid( 'setGridWidth', parent_column.width() );
						}, 20);
					}
			    })

				//if your grid is inside another element, for example a tab pane, you should use its parent's width:
				/**
				$(window).on('resize.jqGrid', function () {
					var parent_width = $(grid_selector).closest('.tab-pane').width();
					$(grid_selector).jqGrid( 'setGridWidth', parent_width );
				})
				//and also set width when tab pane becomes visible
				$('#myTab a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
				  if($(e.target).attr('href') == '#mygrid') {
					var parent_width = $(grid_selector).closest('.tab-pane').width();
					$(grid_selector).jqGrid( 'setGridWidth', parent_width );
				  }
				})
				*/

                var colModel = [];
                switch ("<%=tp%>") { // ubah sini
                    case "P_EMPLOYEE":
                        colModel = [
                           {name:'myac', index:'', width:80, fixed:true, sortable:false, resize:false,
                               formatter:'actions',
                               formatoptions:{
                                   keys:true,
                                   delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback},
                               }
                           },
                           {name:"ID", index:'', width:5, sorttype:"int", editable: false},
                           {name:'E_ID', index:'', width:5, editable: true, editoptions:{size:"10", maxlength:"7"}},
                           {name:'Name', index:'', width:20, editable: true, editoptions:{size:"10", maxlength:"30"}},
                           {name:'Manage_level', index:'', width:8,edittype:"select", editable: true,editoptions:{value:"1:Admin; 2:Cashier; 3:Therapist", size:"8", maxlength:"2"}},
                           {name:'Address', index:'', width:20, editable: true, editoptions:{size:"10", maxlength:"30"}},
                           {name:'Contact_no', index:'', width:10, editable: true, editoptions:{size:"10", maxlength:"30"}},
                           {name:'Join_date', index:'', width:10, sorttype:"date", unformat: pickDate, editable: true, 
                                 editoptions: {
                                  dataInit: function (el) {
                                      $(el).datepicker({
                                          dateFormat: 'dd/mm/yyyy', maxDate: 0, changeMonth: true, changeYear: true
                                      });

                                  }
                                }
                            },
                           {name:'Resign_date', index:'', width:10, sorttype:"date", unformat: pickDate, editable: true,
                                 editoptions: {
                                  dataInit: function (el) {
                                      $(el).datepicker({
                                          dateFormat: 'dd/mm/yyyy', maxDate: 0, changeMonth: true, changeYear: true
                                      });

                                  }
                                }
                           },
                           {name:'Salary_percentage', index:'', width:10, editable: true, editoptions:{size:"10", maxlength:"30"}},
                           {name:'Salary_amount', index:'', width:10, editable: true, editoptions:{size:"10", maxlength:"30"}},
                           {name:'Salary_type', index:'', width:5,edittype:"select", editable: true, editoptions:{value:"D:Daily; M:Monthly", size:"5", maxlength:"30"}}
                       ];
                        break;
                    case "P_MEMBER":
                        colModel = [
                            {name:'myac', index:'', width:80, fixed:true, sortable:false, resize:false,
                                formatter:'actions',
                                formatoptions:{
                                    keys:true,
                                    delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback},
                                }
                            },
                            {name:"ID", index:'', width:20, sorttype:"int", editable: false},
                            {name:'M_ID', index:'', width:20, editable: true, editoptions:{size:"10", maxlength:"7"}},
                            {name:'Name', index:'', width:50, editable: true, editoptions:{size:"10", maxlength:"30"}},
                            {name:'Category', index:'', width:10, editable: true, editoptions:{size:"10", maxlength:"7"}},
                            {name:'Address', index:'', width:50, editable: true, editoptions:{size:"10", maxlength:"30"}},
                            {name:'Contact_no', index:'', width:20, editable: true, editoptions:{size:"10", maxlength:"30"}}
                        ];
                        break;
                    case "P_SUPPLIER":
                        colModel = [
                            {name:'myac', index:'', width:80, fixed:true, sortable:false, resize:false,
                                formatter:'actions',
                                formatoptions:{
                                    keys:true,
                                    delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback},
                                }
                            },
                            {name:"ID", index:'', width:20, sorttype:"int", editable: false},
                            {name:'SU_ID', index:'', width:20, editable: true, editoptions:{size:"10", maxlength:"7"}},
                            {name:'Name', index:'', width:20, editable: true, editoptions:{size:"10", maxlength:"100"}},
                            {name:'Address', index:'', width:30, editable: true, editoptions:{size:"10", maxlength:"500"}},
                            {name:'Contact_no', index:'', width:20, editable: true, editoptions:{size:"10", maxlength:"15"}},
                            {name:'Payment_grace_period', index:'', width:2, editable: true, editoptions:{size:"10", maxlength:"30"}}
                        ];
                        break;
                    case "P_AGENT":
                        colModel = [
                            {name:'myac', index:'', width:80, fixed:true, sortable:false, resize:false,
                                formatter:'actions',
                                formatoptions:{
                                    keys:true,
                                    delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback},
                                }
                            },
                            {name:"ID", index:'', width:20, sorttype:"int", editable: false},
                            {name:'A_ID', index:'', width:20, editable: true, editoptions:{size:"10", maxlength:"7"}},
                            {name:'Name', index:'', width:20, editable: true, editoptions:{size:"10", maxlength:"100"}},
                            {name:'Address', index:'', width:50, editable: true, editoptions:{size:"10", maxlength:"500"}},
                            {name:'Contact_no', index:'', width:20, editable: true, editoptions:{size:"10", maxlength:"15"}},
                            {name:'Agent_fee_percentage', index:'', width:2, editable: true, editoptions:{size:"10", maxlength:"30"}}
                        ];
                        break;
                    case "S_BANK":
                        colModel = [
                            {name:'myac', index:'', width:80, fixed:true, sortable:false, resize:false,
                                formatter:'actions',
                                formatoptions:{
                                    keys:true,
                                    delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback},
                                }
                            },
                            {name:"ID", index:'', width:20, sorttype:"int", editable: false},
                            {name:'BA_ID', index:'', width:20, editable: true, editoptions:{size:"10", maxlength:"7"}},
                            {name:'Bank_name', index:'', width:50, editable: true, editoptions:{size:"10", maxlength:"50"}},
                            {name:'Bank_account', index:'', width:50, editable: true, editoptions:{size:"10", maxlength:"50"}},
                            {name:'Bank_account_name', index:'', width:50, editable: true, editoptions:{size:"10", maxlength:"100"}}
                        ];
                        break;
                    case "S_ITEM":
                        colModel = [
                            {name:'myac', index:'', width:80, fixed:true, sortable:false, resize:false,
                                formatter:'actions',
                                formatoptions:{
                                    keys:true,
                                    delOptions:{recreateForm: true, beforeShowForm:beforeDeleteCallback},
                                }
                            },
                            {name:"ID", index:'', width:20, sorttype:"int", editable: false},
                            {name:'I_ID', index:'', width:20, editable: true, editoptions:{size:"10", maxlength:"10"}},
                            {name:'Item_desc', index:'', width:50, editable: true, editoptions:{size:"10", maxlength:"100"}},
                            {name:'Cat', index:'', width:10, edittype:"select", editable: true, editoptions:{value:"S:S; NS:NS", size:"10", maxlength:"10"}},
                            {name:'Qty', index:'', width:10, editable: true, editoptions:{size:"10", maxlength:"10"}},
                            {name:'Unit_type', index:'', width:10, editable: true, editoptions:{size:"10", maxlength:"20"}},
                            {name:'Report_unit', index:'', width:10, editable: true, editoptions:{size:"10", maxlength:"30"}},
                            {name:'Volume_per_unit', index:'', width:10, editable: true, editoptions:{size:"10", maxlength:"30"}},
                            {name:'Purchase', index:'', width:20, editable: true, editoptions:{size:"10", maxlength:"30"}},
                            {name:'Sales_1', index:'', width:20, editable: true, editoptions:{size:"10", maxlength:"30"}},
                            {name:'Sales_2', index:'', width:20, editable: true, editoptions:{size:"10", maxlength:"30"}},
                            {name:'Sales_3', index:'', width:20, editable: true, editoptions:{size:"10", maxlength:"30"}},
                            {name:'Sales_4', index:'', width:20, editable: true, editoptions:{size:"10", maxlength:"30"}},
                            {name:'Min_stock', index:'', width:5, editable: true, editoptions:{size:"10", maxlength:"30"}}
                        ];
                        break;
                }

				jQuery(grid_selector).jqGrid({
					//direction: "rtl",

					//subgrid options
					subGrid : false,
					//subGridModel: [{ name : ['No','Item Name','Qty'], width : [55,200,80] }],
					//datatype: "xml",
					subGridOptions : {
						plusicon : "ace-icon fa fa-plus center bigger-110 blue",
						minusicon  : "ace-icon fa fa-minus center bigger-110 blue",
						openicon : "ace-icon fa fa-chevron-right center orange"
					},
                    
					//for this example we are using local data
					subGridRowExpanded: function (subgridDivId, rowId) {
						var subgridTableId = subgridDivId + "_t";
						$("#" + subgridDivId).html("<table id='" + subgridTableId + "'></table>");
						$("#" + subgridTableId).jqGrid({
							datatype: 'local',
							data: subgrid_data,
							colNames: ['No','Item Name','Qty'],
							colModel: [
								{ name: 'id', width: 50 },
								{ name: 'name', width: 150 },
								{ name: 'qty', width: 50 }
							]
						});
					},
					data: grid_data,
					datatype: "local",
					height: 250,
					colNames:['Edit',<%=COL%>],
					colModel:colModel,
					viewrecords : true,
					rowNum:100,
					rowList:[100,200,300],
					pager : pager_selector,
					altRows: true,
					//toppager: true,

					multiselect: true,
					//multikey: "ctrlKey",
			        multiboxonly: true,

					loadComplete : function() {
						var table = this;
						setTimeout(function(){
							styleCheckbox(table);

							updateActionIcons(table);
							updatePagerIcons(table);
							enableTooltips(table);
						}, 0);
					},

					editurl: "master1.jsp?tp=<%=tp%>&act=save",
					caption: "Informasi <%=title%>"

					//,autowidth: true,


					/**
					,
					grouping:true,
					groupingView : {
						 groupField : ['name'],
						 groupDataSorted : true,
						 plusicon : 'fa fa-chevron-down bigger-110',
						 minusicon : 'fa fa-chevron-up bigger-110'
					},
					caption: "Grouping"
					*/

				});
				$(window).triggerHandler('resize.jqGrid');//trigger window resize to make the grid get the correct size



				//enable search/filter toolbar
				//jQuery(grid_selector).jqGrid('filterToolbar',{defaultSearch:true,stringResult:true})
				//jQuery(grid_selector).filterToolbar({});


				//switch element when editing inline
				function aceSwitch( cellvalue, options, cell ) {
					setTimeout(function(){
						$(cell) .find('input[type=checkbox]')
							.addClass('ace ace-switch ace-switch-5')
							.after('<span class="lbl"></span>');
					}, 0);
				}
				//enable datepicker
				function pickDate( cellvalue, options, cell ) {
					setTimeout(function(){
						$(cell) .find('input[type=date]')
							.datepicker({format:'mm/dd/yyyy' , autoclose:true});
					}, 0);
				}


				//navButtons
				jQuery(grid_selector).jqGrid('navGrid',pager_selector,
					{ 	//navbar options
						edit: true,
						editicon : 'ace-icon fa fa-pencil blue',
						add: true,
						addicon : 'ace-icon fa fa-plus-circle purple',
						del: true,
						delicon : 'ace-icon fa fa-trash-o red',
						search: true,
						searchicon : 'ace-icon fa fa-search orange',
						view: true,
						viewicon : 'ace-icon fa fa-search-plus grey',
					},
					{
						//edit record form
						//closeAfterEdit: true,
						//width: 700,
						recreateForm: true,
                        afterSubmit: function (response, postdata) {
                            window.location.reload(true);
                        },
						beforeShowForm : function(e) {
							var form = $(e[0]);
							form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
							style_edit_form(form);
						}
					},
					{
						//new record form
						//width: 700,
						closeAfterAdd:true,
						recreateForm: true,
                        afterSubmit: function (response, postdata) {
                            window.location.reload(true);
                        },
  						viewPagerButtons: false,
						beforeShowForm : function(e) {
							var form = $(e[0]);
							form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar')
							.wrapInner('<div class="widget-header" />')
							style_edit_form(form);
						}
					},
					{
						//delete record form
						recreateForm: true,
						beforeShowForm : function(e) {
							var form = $(e[0]);
							if(form.data('styled')) return false;

							form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
							style_delete_form(form);

							form.data('styled', true);
						},
						onClick : function(e) {
//							alert("in delete button");
						}
					},
					{
						//search form
						recreateForm: true,
						afterShowSearch: function(e){
							var form = $(e[0]);
							form.closest('.ui-jqdialog').find('.ui-jqdialog-title').wrap('<div class="widget-header" />')
							style_search_form(form);
						},
						afterRedraw: function(){
							style_search_filters($(this));
						}
						,
						multipleSearch: true,
						/**
						multipleGroup:true,
						showQuery: true
						*/
					},
					{
						//view record form
						recreateForm: true,
						beforeShowForm: function(e){
							var form = $(e[0]);
							form.closest('.ui-jqdialog').find('.ui-jqdialog-title').wrap('<div class="widget-header" />')
						}
					}
				)



				function style_edit_form(form) {
					//enable datepicker on "sdate" field and switches for "stock" field
					form.find('input[name=idtgl]').datepicker({format:'dd-mm-yyyy' , autoclose:true})


					//update buttons classes
					var buttons = form.next().find('.EditButton .fm-button');
					buttons.addClass('btn btn-sm').find('[class*="-icon"]').hide();//ui-icon, s-icon
					buttons.eq(0).addClass('btn-primary').prepend('<i class="ace-icon fa fa-check"></i>');
					buttons.eq(1).prepend('<i class="ace-icon fa fa-times"></i>')

					buttons = form.next().find('.navButton a');
					buttons.find('.ui-icon').hide();
					buttons.eq(0).append('<i class="ace-icon fa fa-chevron-left"></i>');
					buttons.eq(1).append('<i class="ace-icon fa fa-chevron-right"></i>');
				}

				function style_delete_form(form) {
					var buttons = form.next().find('.EditButton .fm-button');
					buttons.addClass('btn btn-sm btn-white btn-round').find('[class*="-icon"]').hide();//ui-icon, s-icon
					buttons.eq(0).addClass('btn-danger').prepend('<i class="ace-icon fa fa-trash-o"></i>');
					buttons.eq(1).addClass('btn-default').prepend('<i class="ace-icon fa fa-times"></i>')
				}

				function style_search_filters(form) {
					form.find('.delete-rule').val('X');
					form.find('.add-rule').addClass('btn btn-xs btn-primary');
					form.find('.add-group').addClass('btn btn-xs btn-success');
					form.find('.delete-group').addClass('btn btn-xs btn-danger');
				}
				function style_search_form(form) {
					var dialog = form.closest('.ui-jqdialog');
					var buttons = dialog.find('.EditTable')
					buttons.find('.EditButton a[id*="_reset"]').addClass('btn btn-sm btn-info').find('.ui-icon').attr('class', 'ace-icon fa fa-retweet');
					buttons.find('.EditButton a[id*="_query"]').addClass('btn btn-sm btn-inverse').find('.ui-icon').attr('class', 'ace-icon fa fa-comment-o');
					buttons.find('.EditButton a[id*="_search"]').addClass('btn btn-sm btn-purple').find('.ui-icon').attr('class', 'ace-icon fa fa-search');
				}

				function beforeDeleteCallback(e) {
					var form = $(e[0]);
					if(form.data('styled')) return false;
					form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
					style_delete_form(form);

					form.data('styled', true);
				}

				function beforeEditCallback(e) {
					var form = $(e[0]);
					form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
					style_edit_form(form);
				}



				//it causes some flicker when reloading or navigating grid
				//it may be possible to have some custom formatter to do this as the grid is being created to prevent this
				//or go back to default browser checkbox styles for the grid
				function styleCheckbox(table) {
				/**
					$(table).find('input:checkbox').addClass('ace')
					.wrap('<label />')
					.after('<span class="lbl align-top" />')


					$('.ui-jqgrid-labels th[id*="_cb"]:first-child')
					.find('input.cbox[type=checkbox]').addClass('ace')
					.wrap('<label />').after('<span class="lbl align-top" />');
				*/
				}


				//unlike navButtons icons, action icons in rows seem to be hard-coded
				//you can change them like this in here if you want
				function updateActionIcons(table) {
					/**
					var replacement =
					{
						'ui-ace-icon fa fa-pencil' : 'ace-icon fa fa-pencil blue',
						'ui-ace-icon fa fa-trash-o' : 'ace-icon fa fa-trash-o red',
						'ui-icon-disk' : 'ace-icon fa fa-check green',
						'ui-icon-cancel' : 'ace-icon fa fa-times red'
					};
					$(table).find('.ui-pg-div span.ui-icon').each(function(){
						var icon = $(this);
						var $class = $.trim(icon.attr('class').replace('ui-icon', ''));
						if($class in replacement) icon.attr('class', 'ui-icon '+replacement[$class]);
					})
					*/
				}

				//replace icons with FontAwesome icons like above
				function updatePagerIcons(table) {
					var replacement =
					{
						'ui-icon-seek-first' : 'ace-icon fa fa-angle-double-left bigger-140',
						'ui-icon-seek-prev' : 'ace-icon fa fa-angle-left bigger-140',
						'ui-icon-seek-next' : 'ace-icon fa fa-angle-right bigger-140',
						'ui-icon-seek-end' : 'ace-icon fa fa-angle-double-right bigger-140'
					};
					$('.ui-pg-table:not(.navtable) > tbody > tr > .ui-pg-button > .ui-icon').each(function(){
						var icon = $(this);
						var $class = $.trim(icon.attr('class').replace('ui-icon', ''));

						if($class in replacement) icon.attr('class', 'ui-icon '+replacement[$class]);
					})
				}

				function enableTooltips(table) {
					$('.navtable .ui-pg-button').tooltip({container:'body'});
					$(table).find('.ui-pg-div').tooltip({container:'body'});
				}

				//var selr = jQuery(grid_selector).jqGrid('getGridParam','selrow');

				$(document).one('ajaxloadstart.page', function(e) {
					$.jgrid.gridDestroy(grid_selector);
					$('.ui-jqdialog').remove();
				});

			});

		</script>
	</body>
	<%}%>
</html>

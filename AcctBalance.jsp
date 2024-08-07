<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta charset="utf-8" />
<title>3R Corporate</title>
<link href="image/3R.png" rel="icon">
		<meta name="description" content="Static &amp; Dynamic Tables" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />

		<!-- bootstrap & fontawesome -->
		<link rel="stylesheet" href="assets/css/bootstrap.min.css" />
		<link rel="stylesheet" href="assets/font-awesome/4.5.0/css/font-awesome.min.css" />

		<!-- page specific plugin styles -->

		<!-- text fonts -->
		<link rel="stylesheet" href="assets/css/fonts.googleapis.com.css" />

		<!-- ace styles -->
		<link rel="stylesheet" href="assets/css/ace.min.css" class="ace-main-stylesheet" id="main-ace-style" />

		<!--[if lte IE 9]>
			<link rel="stylesheet" href="assets/css/ace-part2.min.css" class="ace-main-stylesheet" />
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
<%
	javax.servlet.http.HttpSession ses = request.getSession();   
	if (ses.getAttribute("User") == null){//checking expired session
%>
	   <jsp:forward page="login.jsp"/>
<%
	}                    
        com.ysoft.General gen = new com.ysoft.General();
        com.ysoft.General Gen = new com.ysoft.General();  
        com.ysoft.subgeneral sgen = new com.ysoft.subgeneral(); 
        String tp=gen.gettable(request.getParameter("tp"));
 	    com.ysoft.convertxml convert = new com.ysoft.convertxml();
  		com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
      	java.sql.Connection conn = connMgr.getConnection("db2");
        java.io.PrintWriter log = new java.io.PrintWriter(new java.io.FileWriter(gen.getDataLogFileQuery(), true), true);
      	 com.ysoft.subgeneral queryclass = new com.ysoft.subgeneral();
         String msg="";
          java.util.Vector userdef=sgen.getDataQuery(conn,"USERDEF",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
         String y10=gen.gettable(request.getParameter("Y10"));
         String y11=gen.gettable(request.getParameter("Y11"));
         if(request.getParameter("Y10")==null){ 
            y10=""+(gen.getInt(userdef.get(0))-1);
            y11=gen.gettable(userdef.get(1));
            if(gen.getInt(y10)==0){
                 y10="12";
                 y11=""+(gen.getInt(userdef.get(1))-1);
            }
         }
            if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){
                conn.setAutoCommit(false);
                msg=sgen.update(conn,"ACCTBALDELETEALL",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});                
                if(msg.length()==0) {
                    int hi=gen.getInt(request.getParameter("LINE"));
                    for(int m=1;m<=hi;m++){
                        String acct=gen.gettable(request.getParameter("A"+m));
                        String amt=gen.gettable(request.getParameter("B"+m));
                        msg=sgen.update(conn,"ACCTBALADD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),acct,Gen.gettable(request.getParameter("Y11")),Gen.gettable(request.getParameter("Y10")),amt});
                        if(msg.length()==0) msg=sgen.update(conn,"SETCURRENTGL",new String[]{Gen.gettable(request.getParameter("Y10")),Gen.gettable(request.getParameter("Y11")),gen.gettable(ses.getAttribute("TxtErcode"))});
                        if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"ACCTBALADD",gen.gettable(ses.getAttribute("TxtErcode"))+"|"+Gen.gettable(request.getParameter("Y10"))+"|"+Gen.gettable(request.getParameter("Y11"))+"|"});
                        if(msg.length()>0) break;                        
                    }
                }
                if(msg.length()>0){
                    conn.rollback();
                    msg="(Save Data Failed!!"+msg+")";
                }else{
                    conn.commit();
                    msg="(Save Data Successfully)";
                }
                
                conn.setAutoCommit(true);     
            }
         String[] judul=new String[]{"ACCT ID","ACCOUNT NAME","START BALANCE"};
          java.util.Vector combo1=new java.util.Vector();
          combo1.addElement("1");
          combo1.addElement("2");
          combo1.addElement("3");
          combo1.addElement("4");
          combo1.addElement("5");
          combo1.addElement("6");
          combo1.addElement("7");
          combo1.addElement("8");
          combo1.addElement("9");
          combo1.addElement("10");
          combo1.addElement("11");
          combo1.addElement("12");
          
          java.util.Vector data=sgen.getDataQuery(conn,"ACCOUNTBALANCE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y11,y10,gen.gettable(ses.getAttribute("TxtErcode"))});
          String title="Input Ending Balance";       
          String[] cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode"))};
          java.util.Vector check=sgen.getDataQuery(conn,"ACCTCHECK",cond);
          boolean canedit=false;
          
         /* if(check.size()==0){
            canedit=true;
          }else{
            check=sgen.getDataQuery(conn,"ACCTCHECKBEFORE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y11,y10});
            if(check.size()==0){
                canedit=true;
            }
          }*/
          if(y10.equalsIgnoreCase("5") && y11.equalsIgnoreCase("2023")) canedit=true;
          if(canedit){
            check=sgen.getDataQuery(conn,"ACCTCHECKBEFORE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y11,y10});
            if(check.size()>0){
                canedit=false;
            }
          }
          
          connMgr.freeConnection("db2", conn);
          connMgr.release();
%>


	<body class="no-skin">
    <jsp:include page="menu.jsp" flush ="true"/>
			<div class="main-content">
				<div class="main-content-inner">
                  	<form class="form-horizontal" name="BGA" method="POST" action="AcctBalance.jsp?tp=<%=tp%>" >
					<div class="page-content">
						<div class="page-header">
							<h1><%=title%> <%=msg%></h1>
						</div><!-- /.page-header -->
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
								<div>
									<div id="user-profile-3" class="user-profile row">
                                        <div class="col-sm-offset-1 col-sm-10">
                                            <label class="control-label">Month:                                             
                                             <select name="Y10" onchange="refresh()"><%for(int m=0;m<combo1.size();m++){%><option value="<%=gen.gettable(combo1.get(m)).trim()%>" <%if(y10.trim().equalsIgnoreCase(gen.gettable(combo1.get(m)).trim())) out.print("selected");%> ><%=gen.gettable(combo1.get(m)).trim()%></option><%}%></select></label>
    										<label class="control-label">&nbsp;Year:<input type="text" name="Y11" size="4" maxlength="4" value="<%=y11%>"  onchange="refresh()"> </label>
                                    </div>
                                 </div>
                               </div>
                             </div>
                          </div>
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
										<table id="simple-table" class="table  table-bordered table-hover">
											<thead>
												<tr>													
                                                        <%for(int s=0;s<judul.length;s++){%>         
                                                    	<th><%=judul[s]%>&nbsp;</th>
                                                        
                                                        <%}%>
    											</tr>
											</thead>
											<tbody>
                                                   <%
                                                   int hic=1;
                                                   for(int s=0;s<data.size();s+=judul.length){
                                                   %>         
												<tr>
                                                       <%                                                     
                                                       for(int ss=0;ss<judul.length;ss++){
                                                            if(judul[ss].length()==0)continue;
                                                       %>
                                                            <td <%if(ss>=2) out.print("align=right");%>>
                                                              <%if(ss<2){
                                                                 out.print(gen.gettable(data.get(s+ss)).trim());
                                                                }else{
                                                                    if(canedit){
                                                                %>
                                                                    <input type="hidden" name="A<%=hic%>" value="<%=gen.gettable(data.get(s))%>">
                                                                    <input type="text" name="B<%=hic%>"  style="text-align:right;"  size="20" maxlength="20" value="<%=gen.getNumberFormat(data.get(s+ss),2)%>">                                                               
                                                               <%   }else{%>
                                                                        <%=gen.getNumberFormat(data.get(s+ss),2)%>
                                                               <%   }
                                                               }%>                                                            
                                                            </td>
                                                     <%}%>
												</tr>
                                                <%      hic++;
                                                }%>
											</tbody>
										</table>
								<!-- PAGE CONTENT ENDS -->
							</div><!-- /.col -->
						</div><!-- /.row -->
                          <div class="row" align=center>
                      <%    if(canedit){%>
                      		<button class="btn btn-info" type="button" onclick="setsave();">
                            <input type="hidden" name="act" value="" >
                             <input type="hidden" name="LINE" value="<%=(data.size()/judul.length)%>" >
                      			<i class="ace-icon fa fa-check bigger-110"></i>
                      			Save
                      		</button>
                      <%      }%>      
                        </div>

					</div><!-- /.page-content -->
                 </form>
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
		<script src="assets/js/jquery.dataTables.min.js"></script>
		<script src="assets/js/jquery.dataTables.bootstrap.min.js"></script>
		<script src="assets/js/dataTables.buttons.min.js"></script>
		<script src="assets/js/buttons.flash.min.js"></script>
		<script src="assets/js/buttons.html5.min.js"></script>
		<script src="assets/js/buttons.print.min.js"></script>
		<script src="assets/js/buttons.colVis.min.js"></script>
		<script src="assets/js/dataTables.select.min.js"></script>

		<!-- ace scripts -->
		<script src="assets/js/ace-elements.min.js"></script>
		<script src="assets/js/ace.min.js"></script>

		<!-- inline scripts related to this page -->
		<script type="text/javascript">
            function  setsave(){
                      if(document.BGA.Y10.value=="" ){
                            alert("Month must be filled!");
                            return;
                      }
                      if(document.BGA.Y11.value==""){
                            alert("Year must be filled!");
                            return;
                      }
                      if(document.BGA.Y10.value!="<%=y10%>" || document.BGA.Y11.value!="<%=y11%>"){
                        if(!confirm("Current Month and Year does not match. Do you want to Continue?")){
                            return;
                        }
                      }

                 document.BGA.act.value="Save";
                  BGA.submit();
            }
			jQuery(function($) {
				var active_class = 'active';
				$('#simple-table > thead > tr > th input[type=checkbox]').eq(0).on('click', function(){
					var th_checked = this.checked;//checkbox inside "TH" table header
					
					$(this).closest('table').find('tbody > tr').each(function(){
						var row = this;
						if(th_checked) $(row).addClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', true);
						else $(row).removeClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', false);
					});
				});
				
				//select/deselect a row when the checkbox is checked/unchecked
				$('#simple-table').on('click', 'td input[type=checkbox]' , function(){
					var $row = $(this).closest('tr');
					if($row.is('.detail-row ')) return;
					if(this.checked) $row.addClass(active_class);
					else $row.removeClass(active_class);
				});
			
				
			
				/********************************/
				//add tooltip for small view action buttons in dropdown menu
				$('[data-rel="tooltip"]').tooltip({placement: tooltip_placement});
				
				//tooltip placement on right or left
				function tooltip_placement(context, source) {
					var $source = $(source);
					var $parent = $source.closest('table')
					var off1 = $parent.offset();
					var w1 = $parent.width();
			
					var off2 = $source.offset();
					//var w2 = $source.width();
			
					if( parseInt(off2.left) < parseInt(off1.left) + parseInt(w1 / 2) ) return 'right';
					return 'left';
				}
				
				
				
				
				/***************/
				$('.show-details-btn').on('click', function(e) {
					e.preventDefault();
					$(this).closest('tr').next().toggleClass('open');
					$(this).find(ace.vars['.icon']).toggleClass('fa-angle-double-down').toggleClass('fa-angle-double-up');
				});
				/***************/
				
				
				
				
				
				/**
				//add horizontal scrollbars to a simple table
				$('#simple-table').css({'width':'2000px', 'max-width': 'none'}).wrap('<div style="width: 1000px;" />').parent().ace_scroll(
				  {
					horizontal: true,
					styleClass: 'scroll-top scroll-dark scroll-visible',//show the scrollbars on top(default is bottom)
					size: 2000,
					mouseWheelLock: true
				  }
				).css('padding-top', '12px');
				*/
			
			
			})
            function  refresh(){
                      BGA.submit();
            }
            
		</script>
	</body>
</html>

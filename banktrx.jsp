<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta charset="utf-8" />
    <jsp:include page="title.jsp" flush ="true"/>
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
         String[] judul=new String[]{"DATE","SEQ","ACCOUNT","PAID FROM/TO","TYPE","MY E","DEBIT","CREDIT","BALANCE"};//SEQ,[Acct],Mst_Account.DESCRIPTION,CURR,[Credit],[Debit] 
         
          String title="Bank/Cash Transaction &nbsp;&nbsp;("+gen.gettable(request.getParameter("S1"))+")";       
          
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
          java.util.Vector combo2=sgen.getDataQuery(conn,"BANKYEAR",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
          java.util.Vector userdef=sgen.getDataQuery(conn,"USERDEF",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
         String y10=gen.gettable(request.getParameter("Y10"));
         String y11=gen.gettable(request.getParameter("Y11"));
         if(request.getParameter("Y10")==null){ 
            y10=gen.gettable(userdef.get(0));
            y11=gen.gettable(userdef.get(1));
         }
        String[] cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("S1")),y11,y10};
        String tpx=tp;
        java.util.Vector data=sgen.getDataQuery(conn,tpx,cond);
        java.util.Vector datadesc=sgen.getDataQuery(conn,"TRXBANKDESC",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("S1"))});
        String prevyr=gen.gettable(request.getParameter("Y11")),prevmth=""+(gen.getInt(request.getParameter("Y10"))-1);
        if(prevmth.equalsIgnoreCase("0")){
          prevyr=(gen.getInt(prevyr)-1)+"";
          prevmth="12";
        }            
        
        java.util.Vector balance=sgen.getDataQuery(conn,"TRXBANKBALANCE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),prevyr,prevmth,gen.gettable(request.getParameter("S1"))});
        double bal=0;
        String awal="0";
        String ket="",cur=gen.gettable(request.getParameter("S2"));
        if(datadesc.size()>0){
            ket=gen.gettable(datadesc.get(0)).trim();
        }
        java.util.Vector tmp=new java.util.Vector();
        boolean havebal=false;
        if(balance.size()>0){
            havebal=true;                    
            awal=gen.gettable(balance.get(0)).trim();
            bal=gen.getformatdouble(awal);
        }
        
        
        for(int m=0;m<data.size();m+=8){// [TrxDate],SEQ,[Acct],Mst_Account.DESCRIPTION,TRXTYPE,MY_E,[Credit],[Debit] 
              tmp.addElement(data.get(m));
              tmp.addElement(data.get(m+1));
              tmp.addElement(data.get(m+2));
              tmp.addElement(data.get(m+3));
              tmp.addElement(data.get(m+4));
              tmp.addElement(data.get(m+5));
              tmp.addElement(data.get(m+6));
              tmp.addElement(data.get(m+7));
              bal+=gen.getformatdouble(data.get(m+6))-gen.getformatdouble(data.get(m+7));
              tmp.addElement(bal+"");
        }
        data=tmp;
          connMgr.freeConnection("db2", conn);
          connMgr.release();
%>


	<body class="no-skin">
    <jsp:include page="menu.jsp" flush ="true"/>
			<div class="main-content">
				<div class="main-content-inner">
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
                  						<form class="form-horizontal" name="BGA" method="POST" action="banktrx.jsp?tp=<%=tp%>" >
                                            <label class="control-label">Month:<select name="Y10" onchange="refresh();"><%for(int m=0;m<combo1.size();m++){%><option value="<%=gen.gettable(combo1.get(m)).trim()%>" <%if(y10.trim().equalsIgnoreCase(gen.gettable(combo1.get(m)).trim())) out.print("selected");%>><%=gen.gettable(combo1.get(m)).trim()%></option><%}%></select></label>
    										<label class="control-label">&nbsp;Year:<select  name="Y11" onchange="refresh();"><%for(int m=0;m<combo2.size();m++){%><option value="<%=gen.gettable(combo2.get(m)).trim()%>" <%if(y11.trim().equalsIgnoreCase(gen.gettable(combo2.get(m)).trim())) out.print("selected");%>><%=gen.gettable(combo2.get(m)).trim()%></option><%}%></select>  </label>
                                            <label class="control-label">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="bankdtl.jsp?tp=TRXBANKINPUT&add=true&S1=<%=gen.gettable(request.getParameter("S1"))%>&S2=<%=gen.gettable(request.getParameter("S2"))%>&S3=O&Y10=<%=y10%>&Y11=<%=y11%>"><img width=40 height=40 src=image/spend.png title="Spend Money"></a></b></label>                                            
                                            <label class="control-label">&nbsp;&nbsp;&nbsp;&nbsp;<a href="bankdtl.jsp?tp=TRXBANKINPUT&add=true&S1=<%=gen.gettable(request.getParameter("S1"))%>&S2=<%=gen.gettable(request.getParameter("S2"))%>&S3=I&Y10=<%=y10%>&Y11=<%=y11%>"><img width=35 height=35 src=image/receive.png title="Receive Money"></a></b></label>                                            
                                            <input type="hidden" name="S1" value="<%=gen.gettable(request.getParameter("S1"))%>" />
                                            <input type="hidden" name="S2" value="<%=gen.gettable(request.getParameter("S2"))%>" />
                                          </form>
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
                                                        <%for(int s=0;s<judul.length;s++){
                                                            if(judul[s].length()==0)continue;
                                                        %>         
														<th><%=judul[s]%>&nbsp;</th>
                                                        <%}%>
    											</tr>
											</thead>

											<tbody>
                                                <%if(havebal){%>
                                                	<tr><td colspan=8 align=right><b>Start Balance:</b></td><td  align=right><b><%=gen.getNumberFormat(awal,2)%></b></td></tr>                                                      
                                                <%}%>
                                                   <%
                                                   int hic=1;
                                                   for(int s=0;s<data.size();s+=judul.length){%>
												<tr>                                                      
                                                       <%
                                                     
                                                       for(int ss=0;ss<judul.length;ss++){
                                                            if(judul[ss].length()==0)continue;
                                                            String s3="O";
                                                            if(gen.getformatdouble(data.get(s+6))>0) s3="I";
                                                       %>
                                                            <td <%if(ss>=6) out.print("align=right");%> <%if(ss==0) out.print("nowrap");%>>
                                                            <%if(ss==0){%>
                                                            <a href="bankdtl.jsp?tp=TRXBANKINPUT&canedit=true&P1=<%=gen.gettable(data.get(s+ss)).trim()%>&P2=<%=gen.gettable(data.get(s+5)).trim()%>&Y10=<%=y10%>&Y11=<%=y11%>&S1=<%=gen.gettable(request.getParameter("S1"))%>&S2=<%=gen.gettable(request.getParameter("S2"))%>&S3=<%=s3%>"><%=gen.gettable(data.get(s+ss)).trim()%></a>
                                                            <%}else{
                                                                if(ss<6){
                                                                 out.print(gen.gettable(data.get(s+ss)).trim());
                                                                }else{
                                                                 out.print(gen.getNumberFormat(data.get(s+ss),2));
                                                                }
                                                            %>
                                                            
                                                            <%}%>
                                                            </td>
                                                        <%}%>
												</tr>
                                                <%}%>
                                               
											</tbody>
										</table>
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
		<script src="assets/js/jquery.dataTables.min.js"></script>
		<script src="assets/js/jquery.dataTables.bootstrap.min.js"></script>
		<script src="assets/js/dataTables.buttons.min.js"></script>
        <script src="assets/js/bootstrap-datepicker.min.js"></script>
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

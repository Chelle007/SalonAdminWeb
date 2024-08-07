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
        <jsp:include page="login.jsp" flush ="true"/>
<%
	}else{    
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
         String[] judul=new String[]{"MEMBER NAME","BIRTHDATE","PHONE","BALANCE CARD","MASTER CARD/DISCOUNT CARD","FREE TREATMENT"};
         //[JobNo],[SalesCode],[TypeCode],[TrxDate],[BL],[Voyage],[vmst_customer.codedesc],[TotSalesAmt],[TotCostAmt],[TotProfit]
          String title="Cashier";       
          String src="%"+gen.gettable(request.getParameter("Y14"))+"%";
          String[] cond=new String[]{src,src,src,src};
            String tpx="CASHIER";
        //    System.out.println(tpx);
        java.util.Vector datacard=sgen.getDataQuery(conn,tpx,cond);
        java.util.Vector data=sgen.getDataQuery(conn,"ALLMEMBER1",new String[0]);
        if(gen.gettable(request.getParameter("Y14")).length()>0){
           data=sgen.getDataQuery(conn,"ALLMEMBER2",new String[]{src,src,src,src});
        }
        System.out.println(data.size());
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
                						<form class="form-horizontal" name="BGA" method="POST" action="cashier.jsp?tp=<%=tp%>" >
											<label class="control-label">&nbsp;Search:<input type="text" id="Y14" maxlength="40" size="40" name="Y14"  placeholder="Name/Phone/Card No/Birthdate" value="<%=Gen.gettable(request.getParameter("Y14")).trim()%>" onchange="refresh();"/> </label>
                                           &nbsp;&nbsp; <a href="salesdetail.jsp?tp=SALES&from=CASHIER&add=true">Walk-in Member <img title="Add Sales" width=20 height=20 src=image/plus.gif></a>                                           
                                            </label>
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
														<th><%=judul[s]%>&nbsp;
                                                       </th>
                                                  <%}%>
    											</tr>
											</thead>

											<tbody>
                                                   <%
                                                   int hic=1;
                                                   for(int s=0;s<data.size();s+=4){
                                                        String cardno="",carddisc="",bal="0",cardmst="",cardfree="",cardnomst="";
                                                        String dcarddisc="",dcardmst="",dcardfree="",fcardno="";
                                                        int countfree=0;
                                                        for(int ss=0;ss<datacard.size();ss+=9){
                                                            if(gen.gettable(datacard.get(ss)).trim().equalsIgnoreCase(gen.gettable(data.get(s)).trim()) && gen.gettable(datacard.get(ss+7)).trim().length()>0){
                                                                if(gen.getInt(bal)==0) bal=gen.gettable(datacard.get(ss+4));
                                                                if(gen.gettable(datacard.get(ss+6)).trim().equalsIgnoreCase("MC")){
                                                                    cardmst=gen.gettable(datacard.get(ss+7)).trim();
                                                                    cardnomst=gen.gettable(datacard.get(ss+5)).trim();
                                                                    dcardmst=gen.gettable(datacard.get(ss+8)).trim();
                                                                }else{
                                                                    
                                                                    if(gen.gettable(datacard.get(ss+6)).trim().equalsIgnoreCase("D")){
                                                                            carddisc=gen.gettable(datacard.get(ss+7)).trim();
                                                                            dcarddisc=gen.gettable(datacard.get(ss+8)).trim();
                                                                            cardno=gen.gettable(datacard.get(ss+5)).trim();
                                                                    }else{
                                                                        if(gen.gettable(datacard.get(ss+6)).trim().equalsIgnoreCase("F")){
                                                                            cardfree=gen.gettable(datacard.get(ss+7)).trim();
                                                                            dcardfree=gen.gettable(datacard.get(ss+8)).trim();
                                                                            fcardno=gen.gettable(datacard.get(ss+5)).trim();
                                                                            countfree++;
                                                                        }
                                                                    }
                                                                }
                                                              }
                                                          }
                                                   %>         
												<tr>
                                                          <td ><%=gen.gettable(data.get(s+1)).trim()%></td>
                                                          <td ><%=gen.gettable(data.get(s+2))%></td>
                                                          <td ><%=gen.gettable(data.get(s+3))%></td>
                                                          <td align=right><%=gen.getNumberFormat(bal,0)%></td>
                                                           <td >
                                                          <%if(cardnomst.length()>0){%>
                                                           <a href="treatmentdetail.jsp?from=CASHIER&tp=TREATMENT&T3=<%=gen.gettable(data.get(s)).trim()%>&ST3=<%=gen.gettable(data.get(s+1)).trim()%>&T5=<%=cardmst%>&STB=<%=dcardmst%>&ST1=<%=cardnomst%>"><%=cardnomst%></a>
                                                          <%}else if(dcarddisc.length()>0){%>
                                                          <a href="salesdetail.jsp?tp=SALES&from=CASHIER&add=true&T3=<%=gen.gettable(data.get(s)).trim()%>&ST3=<%=gen.gettable(data.get(s+1)).trim()%>&T5=<%=carddisc%>&STB=<%=dcarddisc%>&ST1=<%=cardno%>"><%=cardno%></a>
                                                          <%}else{%>
                                                            <img title="Add Sales" width=20 height=20 src=image/plus.gif></a>
                                                          <%}%>
                                                           </td>
                                                           <td >
                                                            <%  if(countfree>0){%>
                                                           <a href="treatmentdetail.jsp?from=CASHIER&tp=TREATMENT&T3=<%=gen.gettable(data.get(s)).trim()%>&ST3=<%=gen.gettable(data.get(s+1)).trim()%>&T5=<%=cardfree%>&STB=<%=dcardfree%>&ST1=<%=fcardno%>"><%=countfree%></a>
                                                              <%}%>
                                                           </td>
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
            function upload(){
        		location.href="upload.jsp?tp=UPLOADJOB";
        	}
            
		</script>
	</body>
    <%}%>
</html>

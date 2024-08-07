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
         String[] judul=new String[]{"DATE","REMARK","DEBIT","CREDIT","END BALANCE",""};
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
         String y10=gen.gettable(request.getParameter("Y10"));
         String y11=gen.gettable(request.getParameter("Y11"));
         String y12=gen.gettable(request.getParameter("Y12"));
         if(request.getParameter("Y10")==null){ 
            y10=gen.getToday("M");
            y11=gen.getToday("yyyy");
         }
          java.util.Vector bank=sgen.getDataQuery(conn,"MSTBANK",new String[0]);
          if(bank.size()>0 && y12.length()==0) y12=gen.gettable(bank.get(0)).trim();
          String title="Bank/Cash Transaction";       
          String[] cond=new String[]{y10,y11,y12};
          java.util.Vector data=sgen.getDataQuery(conn,"TRXBANKDETAIL",cond);
          cond=new String[]{y10,y11,y11,y12};
          if(y10.equalsIgnoreCase("1")){
            cond[1]=(gen.getInt(cond[1])-1)+"";
            cond[2]=(gen.getInt(cond[1])-1)+"";
            cond[0]="12";
          }else{
            cond[0]=(gen.getInt(cond[0])-1)+"";
          }
         // System.out.println(cond[0]+","+cond[1]+","+cond[2]+","+cond[3]);
          java.util.Vector balance=sgen.getDataQuery(conn,"TRXBANK",cond);
          
        
        java.util.Vector tmp=new java.util.Vector();
        for(int m=0;m<bank.size();m+=2){
            if(gen.gettable(bank.get(m)).trim().equalsIgnoreCase(y12)){
                int Tbal=0;
                if(balance.size()==0){
                  tmp.addElement(gen.gettable(bank.get(m)));
                  tmp.addElement("Balance");
                  tmp.addElement("0");
                  tmp.addElement("0");
                  tmp.addElement("0");
                  tmp.addElement("");
                }else{
                  
                  int credit=gen.getInt(balance.get(1));
                  int debit=gen.getInt(balance.get(2));
                  int bal=debit-credit;
                  tmp.addElement(gen.gettable(bank.get(m)));
                  tmp.addElement("Balance");
                  tmp.addElement(bal+"");
                  tmp.addElement("0");
                  tmp.addElement(bal+"");
                  tmp.addElement("");
                  Tbal=bal;
                }
              for(int mx=0;mx<data.size();mx+=8){// [TrxDate],[Seq],[Bank],[Credit],[Debit],[TrxType],[Refcode],[Remarks] FROM [BankC
                    tmp.addElement(gen.gettable(data.get(mx)));
                    if(gen.gettable(data.get(mx+7)).trim().length()==0){
                        if(gen.gettable(data.get(mx+5)).trim().equalsIgnoreCase("S")){
                            tmp.addElement("Sales id : " +gen.gettable(data.get(mx+6)).trim());
                        }else if(gen.gettable(data.get(mx+5)).trim().equalsIgnoreCase("P")){
                            tmp.addElement("Purchase id : " +gen.gettable(data.get(mx+6)).trim());
                        }else{
                            tmp.addElement("Ref No : "+gen.gettable(data.get(mx+6)).trim());
                        }                        
                    }else{
                        tmp.addElement(gen.gettable(data.get(mx+7)));
                    }
                    tmp.addElement(gen.gettable(data.get(mx+4)));
                    tmp.addElement(gen.gettable(data.get(mx+3)));
                    Tbal+=gen.getInt(data.get(mx+4))-gen.getInt(data.get(mx+3));
                    tmp.addElement(Tbal+"");
                     tmp.addElement(gen.gettable(data.get(mx+6)));
              }
            }
        }
     //   System.out.println(y10);
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
                  						<form class="form-horizontal" name="BGA" method="POST" action="banktransaction.jsp?tp=<%=tp%>" >
                                            <label class="control-label">Month:<select name="Y10" onchange="refresh();"><%for(int m=0;m<combo1.size();m++){%><option value="<%=gen.gettable(combo1.get(m)).trim()%>" <%if(y10.trim().equalsIgnoreCase(gen.gettable(combo1.get(m)).trim())) out.print("selected");%>><%=gen.gettable(combo1.get(m)).trim()%></option><%}%></select></label>
        									<label class="control-label">&nbsp;Year:<input type="text" id="Y11" maxlength="4" size="4" name="Y11" value="<%=y11%>"  placeholder="Year" onchange="refresh();">  </label>
                                            <label class="control-label">Bank:<select name="Y12" onchange="refresh();"><%for(int m=0;m<bank.size();m+=2){%><option value="<%=gen.gettable(bank.get(m)).trim()%>" <%if(y12.trim().equalsIgnoreCase(gen.gettable(bank.get(m)).trim())) out.print("selected");%>><%=gen.gettable(bank.get(m+1)).trim()%></option><%}%></select></label>
                                           <label class="control-label">&nbsp;&nbsp;&nbsp;<a href="bankdtl.jsp?tp=TRXBANKINPUT&add=true&S1=<%=y12%>&S3=O&Y10=<%=y10%>&Y11=<%=y11%>"><img width=40 height=40 src=image/spend.png title="Spend Money"></a></b></label>                                            
                                            <label class="control-label">&nbsp;&nbsp;&nbsp;<a href="bankdtl.jsp?tp=TRXBANKINPUT&add=true&S1=<%=y12%>&S3=I&Y10=<%=y10%>&Y11=<%=y11%>"><img width=35 height=35 src=image/receive.png title="Receive Money"></a></b></label>                                            
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
                                                   <%
                                                   int hic=1;
                                                   for(int s=0;s<data.size();s+=judul.length){
                                                   %>         
												<tr>
                                                       <%
                                                       for(int ss=0;ss<judul.length;ss++){
                                                            if(judul[ss].length()==0)continue;
                                                            String st="I";
                                                            if(gen.getInt(data.get(s+3))>0) st="O";
                                                       %>
                                                            <td <%if(ss>=2) out.print("align=right");%>>
                                                            <%if(ss==0 && !gen.gettable(data.get(ss+s+1)).equalsIgnoreCase("Balance")){%>
                                                            <a href="bankdtl.jsp?tp=TRXBANKDETAIL&canedit=true&Y10=<%=y10%>&Y11=<%=y11%>&S1=<%=y12%>&S2=<%=gen.gettable(data.get(s+ss)).trim()%>&S3=<%=st%>&P1=<%=gen.gettable(data.get(s))%>&P2=<%=gen.gettable(data.get(s+5))%>&S4=<%=gen.gettable(data.get(s+5))%>"><%=gen.gettable(data.get(s+ss)).trim()%></a>
                                                            <%}else{
                                                                if(ss<2){
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

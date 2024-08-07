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
         String crntyear="",crntmonth="";
         if(request.getParameter("Y10")==null){ 
            y10=gen.gettable(userdef.get(0));
            y11=gen.gettable(userdef.get(1));
         }
         if(userdef.size()>0){
            crntmonth=gen.gettable(userdef.get(0));
            crntyear=gen.gettable(userdef.get(1));

         }
         String S1=gen.gettable(request.getParameter("S1"));
         String S2=gen.gettable(request.getParameter("S2"));
         
          String prevy=y11,prevm=(gen.getInt(y10)-1)+"";
          String mth=y10;
          if(mth.length()==1)mth="0"+mth;
           
          if(y10.equalsIgnoreCase("1")){
            prevy=(gen.getInt(prevy)-1)+"";
            prevm="12";
          }
          if(request.getParameter("S1")==null){
            S1=prevm;
            S2=prevy;
          }
          
         String[] judul=new String[]{"ID","SRC","DATE","MEMO","DEBIT","CREDIT","NET ACTIVITY","ENDING BALANCE"};
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
          java.util.Vector combo2=sgen.getDataQuery(conn,"GLYEAR",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
          if(combo2.size()==0){ 
            combo2.addElement(y11);
          }
          //ID#	Src	Date	Memo	Debit	Credit	Job No.	Net Activity	Ending Balance

          java.util.Vector balance=sgen.getDataQuery(conn,"ACCOUNTBALANCECHILD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),prevy,prevm,gen.gettable(ses.getAttribute("TxtErcode"))});
          String title="General Ledger (Detail)";       
          String[] cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y11,y10};
          java.util.Vector post=sgen.getDataQuery(conn,"POSTGLSUMM",cond);
          java.util.Vector xtampung=new java.util.Vector();
          for(int s=0;s<balance.size();s+=3){
            String acct=gen.gettable(balance.get(s));
            xtampung.addElement("<b>"+balance.get(s));
            xtampung.addElement("<b>"+balance.get(s+1));
            xtampung.addElement("");
            xtampung.addElement("");
            xtampung.addElement("");
            xtampung.addElement("");
            xtampung.addElement("<b>"+"Start Balance:");
            xtampung.addElement(balance.get(s+2));
            double bal=gen.getformatdouble(balance.get(s+2));
            double td=0,tc=0,tn=0;
            for(int ss=0;ss<post.size();ss+=7){
                if(acct.trim().equalsIgnoreCase(gen.gettable(post.get(ss+4)).trim()) || acct.trim().equalsIgnoreCase(gen.gettable(post.get(ss+5)).trim())){
                    xtampung.addElement(post.get(ss));
                    xtampung.addElement(post.get(ss+1));
                    xtampung.addElement(post.get(ss+2));
                    xtampung.addElement(post.get(ss+3));
                    String Debit=gen.gettable(post.get(ss+6));
                    String Credit="";
                    
                    if(acct.trim().equalsIgnoreCase(gen.gettable(post.get(ss+5)).trim())){
                        Debit="";
                        Credit=gen.gettable(post.get(ss+6));
                    }
                    bal+=gen.getformatdouble(Debit)-gen.getformatdouble(Credit);
                    xtampung.addElement(Debit);
                    xtampung.addElement(Credit);
                    xtampung.addElement("");
                    td+=gen.getformatdouble(Debit);
                    tc+=gen.getformatdouble(Credit);
                    xtampung.addElement(bal+"");
                }
            }
            tn=td-tc;
            xtampung.addElement("");
            xtampung.addElement("");
            xtampung.addElement("");
            xtampung.addElement("<b>Total:</b>");
            xtampung.addElement(""+td);
            xtampung.addElement(""+tc);
            xtampung.addElement(""+tn);
            xtampung.addElement(""+bal);
            xtampung.addElement("");
            xtampung.addElement("");
            xtampung.addElement("");
            xtampung.addElement("");
            xtampung.addElement("");
            xtampung.addElement("");
            xtampung.addElement("");
            xtampung.addElement("");
          }
          
          post=xtampung;
          
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
									<div id="user-profile-3" class="user-profile row">
                                        <div class="col-sm-offset-1 col-sm-10">
                                            <div>
                                                    <label class="control-label">&nbsp;Current Month-Year:<b><%=gen.mon[gen.getInt(crntmonth)-1]%>-<%=crntyear%></b>
                                                      <input type="hidden" name="Y10" value="<%=y10%>">
                                                      <input type="hidden" name="Y11" value="<%=y11%>">
                                                      <input type="hidden" name="act" value="">
                                                    </label>
                                           </div>                                        
                                            <div>
            										<label class="control-label">&nbsp;</label>
                                           </div>    
                                        </div>                                        
											<div class="tabbable">
												<ul class="nav nav-tabs padding-16">
													<li class="active">
														<a data-toggle="tab" href="#edit-post">
															<i class="green ace-icon fa fa-pencil-square-o bigger-125"></i>
															GL Detail
														</a>
													</li>
												</ul>
												<div class="tab-content profile-edit-tab-content">
												<div id="edit-post"  class="tab-pane in active">
                                                    <div>
                                                        <table id="simple-table2" class="table  table-bordered table-hover">
            												<thead>
            													<tr>
                                                                    <th>ID#</th>
                                                                    <th>SRC</th>
                                                                    <th>DATE</th>
                                                                    <th>MEMO</th>
                                                                    <th>DEBIT</th>
                                                                    <th>CREDIT</th>
                                                                    <th>NET ACTIVITY</th>
                                                                    <th>BALANCE</th>                                                                    
            													</tr>
            												</thead>                
            												<tbody>
                                                                <%  
                                                                int d=2;                                                              
                                                                for(int i=0;i<post.size();i+=8){
                                                                    String TMB="";
                                                                    if(gen.gettable(post.get(i+6)).equalsIgnoreCase("<b>Start Balance:")){
                                                                        TMB=" colspan=3";
                                                                       // d=0;
                                                                    }
                                                                    
                                                                    /*if(gen.gettable(post.get(i)).trim().equalsIgnoreCase("12120")||gen.gettable(post.get(i)).trim().equalsIgnoreCase("12130")||gen.gettable(post.get(i)).trim().equalsIgnoreCase("12140")
                                                                    ||gen.gettable(post.get(i)).trim().equalsIgnoreCase("12220")||gen.gettable(post.get(i)).trim().equalsIgnoreCase("12230")
                                                                     ||gen.gettable(post.get(i)).trim().equalsIgnoreCase("22020")||gen.gettable(post.get(i)).trim().equalsIgnoreCase("22030")
                                                                    ){
                                                                        d=2;
                                                                    }*/
                                                                %>
                                            						<tr>
                                                                        <td nowrap><%=gen.gettable(post.get(i)).trim()%></td>
                                                                        <td nowrap <%=TMB%>><%=gen.gettable(post.get(i+1)).trim()%></td>
                                                                        <%if(TMB.length()==0){%><td nowrap><%=gen.gettable(post.get(i+2)).trim()%></td><%}%>
                                                                        <%if(TMB.length()==0){%><td nowrap><%=gen.gettable(post.get(i+3)).trim()%></td><%}%>
                                                                        <td nowrap align=right><%if(gen.gettable(post.get(i+4)).length()>0){%><%=gen.getNumberFormat(post.get(i+4),d)%><%}%></td>
                                                                        <td nowrap align=right><%if(gen.gettable(post.get(i+5)).length()>0){%><%=gen.getNumberFormat(post.get(i+5),d)%><%}%></td>
                                                                        <td nowrap align=right><%if(gen.gettable(post.get(i+6)).length()>0 && !gen.gettable(post.get(i+6)).equalsIgnoreCase("<b>Start Balance:")){%><%=gen.getNumberFormat(post.get(i+6),d)%><%}else{%><%=gen.gettable(post.get(i+6))%><%}%></td>
                                                                        <td nowrap align=right><%if(gen.gettable(post.get(i+7)).length()>0){%><%=gen.getNumberFormat(post.get(i+7),d)%><%}%></td>                                                                                                                  					    </tr>
                                                                    </tr>
                                                                <%}%>
            												</tbody>
            											</table>
                                                    </div>
												</div>
											</div><!--end tab-->                                                
                                       <!-- </div>-->
                                    </div><!--div id="user-profile-3"-->
                            </div>
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
                      basic.submit();
            }
            
	function setLink(Pdata,FieldName,FieldName2,cond,listinactive){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
            
            
		</script>
	</body>
</html>

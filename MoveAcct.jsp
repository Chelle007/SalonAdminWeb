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
         
           String crntyear="",crntmonth="",ty="",tm="";
           if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){            
                java.util.Vector userdef=sgen.getDataQuery(conn,"USERDEF",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
                if(userdef.size()>0){
                  crntmonth=gen.gettable(userdef.get(0));
                  crntyear=gen.gettable(userdef.get(1));
                  if(crntmonth.length()==1)crntmonth="0"+crntmonth;
                }
                String prevy=crntyear,prevm=(gen.getInt(crntmonth)-1)+"";
                 
                if(prevm.equalsIgnoreCase("0")){
                  prevy=(gen.getInt(prevy)-1)+"";
                  prevm="12";
                }
                String trx=Gen.gettable(request.getParameter("Y13"));
                java.util.Vector sd=gen.getElement('-',trx+"-");
                if(sd.size()>0){
                      tm=gen.gettable(sd.get(1));
                      ty=gen.gettable(sd.get(2));
                }
                if(gen.getInt(ty)==gen.getInt(crntyear) && gen.getInt(tm)<gen.getInt(crntmonth)){
                      conn.setAutoCommit(false);            
                    java.util.Vector gl=sgen.getDataQuery(conn,"GLMAX",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),ty.substring(2)+tm+"%"});
                    int SEQ=1;
                    if(gl.size()>0){
                        String x=gen.gettable(gl.get(0)).trim().substring(4);
                        SEQ=(gen.getInt(x)+1);
                    }
                    String xGLID=SEQ+"";
                    String glid=SEQ+"";
                    for(int m=xGLID.length();m<5;m++){
                        glid="0"+glid;
                    }
                    glid=ty.substring(2)+tm+glid;
                    
                    java.util.Vector dta=(java.util.Vector)ses.getAttribute("OLDGL");//lepasin
                    if(msg.length()==0) msg=sgen.update(conn,"GLADD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),glid,gen.gettable(request.getParameter("Y13")),"IDR","","TAXCLAIM",""});
                    double tot=0;
                    for(int sm=0;sm<dta.size();sm+=6){
                        String acct=gen.gettable(dta.get(sm));
                        String idrd=gen.gettable(dta.get(sm+2));
                        String idrc=gen.gettable(dta.get(sm+3));
                        tot+=gen.getformatdouble(dta.get(sm+3));
                        String job=gen.gettable(dta.get(sm+4));
                        String rem=gen.gettable(dta.get(sm+5));
                        String[] xc=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),glid,acct,idrd,idrc,"1",idrd,idrc,job,rem,""};
                        if(msg.length()==0) msg=sgen.update(conn,"GLDETAILADD",xc);                
                    }
                    if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"MOVEACCTADD",glid+"|"});
                    if(msg.length()==0){
                        int startm=gen.getInt(tm);
                        int endm=gen.getInt(prevm);
                        if(startm>endm){
                            endm+=12;
                        }
                        String loopy=ty;
                        String acct1="23330";
                        String acct2="64302";
                        for(int smm=startm;smm<=endm;smm++){
                          int loopm=smm;
                          if(smm>12){
                            loopy=""+(gen.getInt(loopy)+1);
                            loopm=1;
                          }
                          java.util.Vector bal=sgen.getDataQuery(conn,"ACCOUNTMONTHLY",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),loopy,loopm+"",acct1});
                          if(bal.size()>0){
                              double amt=gen.getformatdouble(bal.get(0))-tot;       
                              if(msg.length()==0) msg=sgen.update(conn,"ACCTBALUPDATE",new String[]{amt+"",gen.gettable(ses.getAttribute("TxtErcode")),acct1,loopy,loopm+""});
                          }else{
                              double amt=-1*tot;       
                              if(msg.length()==0) msg=sgen.update(conn,"ACCTBALADD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),acct1,loopy,loopm+"",amt+""});
                          }                
                          bal=sgen.getDataQuery(conn,"ACCOUNTMONTHLY",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),loopy,loopm+"",acct2});
                          if(bal.size()>0){
                              double amt=gen.getformatdouble(bal.get(0))+tot;       
                              if(msg.length()==0) msg=sgen.update(conn,"ACCTBALUPDATE",new String[]{amt+"",gen.gettable(ses.getAttribute("TxtErcode")),acct2,loopy,loopm+""});
                          }else{
                              double amt=tot;       
                              if(msg.length()==0) msg=sgen.update(conn,"ACCTBALADD",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),acct2,loopy,loopm+"",amt+""});
                          }                
                        }
                        
                    }
    
                    if(msg.length()>0){
                        conn.rollback();
                        msg="(Data Save Failed!!"+msg+")";
                    }else{
                        conn.commit();
                        msg="(Saved Successfully)";
                    }     
                    conn.setAutoCommit(true);   
                }else{
                    msg="Invalid Ledger Date!The Date is not posting.";                    
                }
        }         
          //[AcctNo],[description],[IDRAmt],jobno,remarks  
         String[] judul=new String[]{"ACCOUNT","DESCRIPTION","DEBIT","CREDIT","JOBNO","REMARK"};
          
          String title="Move Account";       
          String[] cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("Y11")),gen.gettable(request.getParameter("Y12"))};
          java.util.Vector data=sgen.getDataQuery(conn,tp,cond);
          java.util.Vector tamp=new java.util.Vector();
          for(int s=0;s<data.size();s+=6){
                for(int ss=0;ss<6;ss++) tamp.addElement(data.get(s+ss));
                tamp.addElement("64302");
                tamp.addElement("TAX 23");
                tamp.addElement(data.get(s+3));
                tamp.addElement("0");
                tamp.addElement(data.get(s+4));
                tamp.addElement(data.get(s+5));                                                                                              
          }
          ses.setAttribute("OLDGL",tamp);
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
                                                  <form class="form-horizontal" name="basic" method="POST" action="MoveAcct.jsp?tp=MOVEACCT" >
                                                    <div>                                  						
                                                    Job Date From:<input class="input-medium date-picker" name="Y11"  id="Y11" type="text" data-date-format="dd-mm-yyyy" value="<%=gen.gettable(request.getParameter("Y11"))%>" placeholder="dd-mm-yyyy"  onchange="refresh();"/>
													&nbsp;&nbsp;Date To:<input class="input-medium date-picker" name="Y12"  id="Y12" type="text" data-date-format="dd-mm-yyyy" value="<%=gen.gettable(request.getParameter("Y12"))%>" placeholder="dd-mm-yyyy"  onchange="refresh();"/>
                                                    &nbsp;&nbsp;Ledger Date:<input class="input-medium date-picker" name="Y13"  id="Y13" type="text" data-date-format="dd-mm-yyyy" value="<%=gen.gettable(request.getParameter("Y13"))%>" placeholder="dd-mm-yyyy"  />
                                                    </div>
                                                    <div>
                										<table id="simple-table" class="table  table-bordered table-hover">
                											<thead>
                												<tr>													                                                                    
                                                                        <%for(int s=0;s<judul.length;s++){%>         
                														<td align=center><b><%=judul[s]%>&nbsp;</td>
                                                                        <%}%>
                    											</tr>
                											</thead>
                
                											<tbody>                                                                   
                                                               <%  int hic=1;
                                                            for(int s=0;s<tamp.size();s+=judul.length){%>         
                												<tr>
                                                                   <%for(int ss=0;ss<judul.length;ss++){%>
                                                                        <td nowrap><%=gen.gettable(tamp.get(s+ss)).trim()%></td>
                                                                    <%}%>
                												</tr>
                                                        <%}//%>
            											</tbody>
            										</table>
                                                    </div>
                                                    <div class="space-4"></div>
    												<div class="clearfix form-actions">
    													<div class="col-md-offset-3 col-md-9">
    														<button class="btn btn-info" type="button" onclick="setsave('4');">
    															<i class="ace-icon fa fa-check bigger-110"></i>
    															Save
    														</button>
    													</div>
    												</div>
                                                      <input type="hidden" name="act" value="">
          										</form>
                                        </div>
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
            function  setsave(Parm){
                     document.basic.act.value="Save";
                     basic.submit();
            }
            
	function setLink(Pdata,FieldName,FieldName2,cond,listinactive){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
            
		</script>
	</body>
</html>

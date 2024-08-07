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
            if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("DEL")){
                conn.setAutoCommit(false);
                java.util.Vector checkedit=sgen.getDataQuery(conn,"APPAYFOUND",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1"))});
                boolean canedit=true;
                if(checkedit.size()>0){
                    canedit=false;
                }
                if(canedit){
                    checkedit=sgen.getDataQuery(conn,"ARPAYFOUND",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1"))});
                    if(checkedit.size()>0){
                        canedit=false;
                    }
                }
                if(!canedit){
                    msg="The Data can not delete!!Sales/Cost already paid.";
                }
                if(msg.length()==0) msg=sgen.update(conn,"JOBNEWDELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1"))});
                if(msg.length()==0) msg=sgen.update(conn,"JOBCOSTDELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1"))});
                if(msg.length()==0) msg=sgen.update(conn,"JOBSALESDELETE",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),Gen.gettable(request.getParameter("S1"))});
                if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"JOBNEWDELETE",gen.gettable(ses.getAttribute("TxtErcode"))+"|"+gen.gettable(request.getParameter("S1"))+"|"});
                if(msg.length()>0){
                    conn.rollback();
                    msg="(Delete Data Failed!!"+msg+")";
                }else{
                    conn.commit();
                    msg="(Delete Data Successfully)";
                }
                
                conn.setAutoCommit(true);     
            }
        

         String[] judul=new String[]{"JOBNO","SALES","TYPE","DATE","BL NO.","VOYAGE","CUSTOMER","TOTAL SALES","TOTAL COST","PROFIT","STS MYOB"};
         //[JobNo],[SalesCode],[TypeCode],[TrxDate],[BL],[Voyage],[vmst_customer.codedesc],[TotSalesAmt],[TotCostAmt],[TotProfit]
          String title="List of Job";       
          String[] cond=new String[0];
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
          java.util.Vector combo2=sgen.getDataQuery(conn,"JOBNEWYEAR",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
            
            String f1=gen.gettable(request.getParameter("Y10"));
            if(request.getParameter("Y10")==null ||f1.length()==0){
                if(ses.getAttribute("MTHJOB")!=null){
                    f1=gen.gettable(ses.getAttribute("MTHJOB"));
                }else{
                  if(combo1.size()>0){
                      f1=gen.getInt(gen.getToday("MM"))+"";
                  }            
                }
            }
            ses.setAttribute("MTHJOB",f1);
            String f2=gen.gettable(request.getParameter("Y11"));
            if(request.getParameter("Y11")==null ||f2.length()==0){
                if(combo2.size()>0) f2=gen.gettable(combo2.get(0));
            }
            cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),f1,f2};
            String tpx=tp;
            if (gen.gettable(request.getParameter("Y16")).length()>0){
                tpx=tp+"6";
                cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("Y16")),gen.gettable(request.getParameter("Y16"))};
                f1="";
                f2="";
            }else if (gen.gettable(request.getParameter("Y17")).length()>0){
                tpx=tp+"7";
                cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),"%"+gen.gettable(request.getParameter("Y17"))+"%"};
                f1="";
                f2="";
            }else if (gen.gettable(request.getParameter("Y18")).length()>0){
                tpx=tp+"8";
                cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),"%"+gen.gettable(request.getParameter("Y18"))+"%"};
                f1="";
                f2="";
            }else if (gen.gettable(request.getParameter("Y15")).length()>0){
                tpx=tp+"5";
                cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),"%"+gen.gettable(request.getParameter("Y15"))+"%"};
                f1="";
                f2="";
            }else if (gen.gettable(request.getParameter("Y14")).length()>0){
                tpx=tp+"4";
                cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("Y14"))};
                f1="";
                f2="";
            }else if(gen.gettable(request.getParameter("Y12")).length()>0 && gen.gettable(request.getParameter("Y13")).length()>0){
                tpx=tp+"3";
                cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("Y12")),gen.gettable(request.getParameter("Y13"))};
                f1="";
                f2="";
            }else if(gen.gettable(request.getParameter("Y12")).length()>0){
                tpx=tp+"1";
                cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("Y12"))};
                f1="";
                f2="";
            }else if(gen.gettable(request.getParameter("Y13")).length()>0){
                tpx=tp+"2";
                cond=new String[]{gen.gettable(ses.getAttribute("TxtErcode")),gen.gettable(request.getParameter("Y13"))};
                f1="";
                f2="";
            }
        java.util.Vector data=sgen.getDataQuery(conn,tpx,cond);
        ////System.out.println(gen.gettable(request.getParameter("Y1")));
        if(gen.gettable(request.getParameter("Y1")).length()>0){
            java.util.Vector ttm=new java.util.Vector();
            for(int m=0;m<data.size();m+=11){
           // System.out.println(gen.gettable(data.get(m+2)).trim());
                if(gen.gettable(request.getParameter("Y1")).equalsIgnoreCase(gen.gettable(data.get(m+2)).trim())){
                    for(int mm=0;mm<11;mm++) ttm.addElement(data.get(m+mm));
                }
            }
            data=ttm;
        }
        if(request.getParameter("Y0")!=null ){
            java.util.Vector ttm=new java.util.Vector();
            for(int m=0;m<data.size();m+=11){
            //System.out.println(gen.gettable(data.get(m+2)).trim());
                if(gen.gettable(request.getParameter("Y0")).equalsIgnoreCase(gen.gettable(data.get(m+10)).trim())||gen.gettable(request.getParameter("Y0")).equalsIgnoreCase("A")){
                    for(int mm=0;mm<11;mm++) ttm.addElement(data.get(m+mm));
               // }else if(gen.gettable(data.get(m+10)).trim().length()==0 && gen.gettable(request.getParameter("Y0")).equalsIgnoreCase("")){
                   // for(int mm=0;mm<11;mm++) ttm.addElement(data.get(m+mm));
                }
            }
            data=ttm;
        }
//        String sts=gen.gettable(request.getParameter("Y14"));
        //System.out.println("job>>"+data.size()+","+f1+","+f2+",tpx="+tpx);     
          connMgr.freeConnection("db2", conn);
          connMgr.release();
%>


	<body class="no-skin">
    <jsp:include page="menu.jsp" flush ="true"/>
			<div class="main-content">
				<div class="main-content-inner">
					<div class="page-content">
						<div class="page-header">
							<h1><%=title%> <%=msg%>&nbsp;&nbsp;&nbsp;<a href="javascript:upload()"><img width=30 height=30 src=image/upload.jfif ></a></h1>
						</div><!-- /.page-header -->
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
								<div>
									<div id="user-profile-3" class="user-profile row">
                                        <div class="col-sm-offset-1 col-sm-10">
                						<form class="form-horizontal" name="BGA" method="POST" action="jobnew.jsp?tp=<%=tp%>" >
                                            <label class="control-label">Month:<select name="Y10" onchange="refresh();"><option></option><%for(int m=0;m<combo1.size();m++){%><option value="<%=gen.gettable(combo1.get(m)).trim()%>" <%if(f1.trim().equalsIgnoreCase(gen.gettable(combo1.get(m)).trim())) out.print("selected");%>><%=gen.gettable(combo1.get(m)).trim()%></option><%}%></select></label>
    										<label class="control-label">&nbsp;Year:<select  name="Y11" onchange="refresh();"><option></option><%for(int m=0;m<combo2.size();m++){%><option value="<%=gen.gettable(combo2.get(m)).trim()%>" <%if(f2.trim().equalsIgnoreCase(gen.gettable(combo2.get(m)).trim())) out.print("selected");%>><%=gen.gettable(combo2.get(m)).trim()%></option><%}%></select>  </label>
											<label class="control-label">&nbsp;Start Date:<input class="input-medium date-picker" name="Y12"  id="Y12" size="10" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(request.getParameter("Y12"))%>" placeholder="dd-mm-yyyy"  onchange="refresh();"/> </label>
											<label class="control-label">&nbsp;End Date:<input class="input-medium date-picker" name="Y13"  id="Y13" size="10"  type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(request.getParameter("Y13"))%>" placeholder="dd-mm-yyyy"  onchange="refresh();"/> </label>
											<label class="control-label">&nbsp;Job No:<input type="text" id="Y14" maxlength="11" size="10" name="Y14"  placeholder="Job No" value="<%=Gen.gettable(request.getParameter("Y14")).trim()%>" onchange="refresh();"/> </label>
											<label class="control-label">&nbsp;Container No:<input type="text" id="Y15" maxlength="11" size="12" name="Y15"  placeholder="Container No" value="<%=Gen.gettable(request.getParameter("Y15")).trim()%>" onchange="refresh();"/></label>
											<label class="control-label">&nbsp;Voyage No:<input type="text" id="Y17" maxlength="30" size="20" name="Y17"  placeholder="Voyage No" value="<%=Gen.gettable(request.getParameter("Y17")).trim()%>" onchange="refresh();"/> </label>
											<label class="control-label">&nbsp;BL No:<input type="text" id="Y18" maxlength="30" size="20" name="Y18"  placeholder="BL No" value="<%=Gen.gettable(request.getParameter("Y18")).trim()%>" onchange="refresh();"/> </label>
											<label class="control-label">&nbsp;MYOB:<input type="text" id="Y16" maxlength="10" size="8" name="Y16"  placeholder="MYOB" value="<%=Gen.gettable(request.getParameter("Y16")).trim()%>" onchange="refresh();"/></label>
    										<label class="control-label">Type:<select  name="Y1" onchange="refresh();">
                                            <option></option>
                                            <option value="EXP" <%if(gen.gettable(request.getParameter("Y1")).equalsIgnoreCase("EXP")) out.print("selected");%>>EXP</option>
                                            <option value="IMP" <%if(gen.gettable(request.getParameter("Y1")).equalsIgnoreCase("IMP")) out.print("selected");%>>IMP</option>
                                            </select>  </label>
    										<label class="control-label">Sts Myob:<select  name="Y0" onchange="refresh();">
                                            <option></option>
                                            <option value="C" <%if(gen.gettable(request.getParameter("Y0")).equalsIgnoreCase("C")) out.print("selected");%>>C</option>
                                            <option value="A" <%if(gen.gettable(request.getParameter("Y0")).equalsIgnoreCase("A")||request.getParameter("Y0")==null) out.print("selected");%>>All</option>
                                            </select>  </label>
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
														<th><%=judul[s]%>&nbsp;<%if(s==0){%><a href="jobdetailnew.jsp?add=true&tp=<%=request.getParameter("tp")%>"><img width=20 height=20 src=image/plus.gif></a><%}%></th>
                                                        <%}%>
                                                    <th>DELETE</th>
    											</tr>
											</thead>

											<tbody>
                                                   <%
                                                   int hic=1;
                                                   for(int s=0;s<data.size();s+=judul.length){%>         
												<tr>
                                                       <%for(int ss=0;ss<judul.length;ss++){
                                                            if(judul[ss].length()==0)continue;
                                                            String tmb="";
                                                            if(gen.gettable(data.get(s+ss)).startsWith("-") && ss==9){
                                                                tmb="<font color=red>";
                                                            }
                                                       %>
                                                            <td <%if(ss>=7) out.print("align=right");%>><%=tmb%>
                                                            <%if(ss==0){%>
                                                            <a href="jobdetailnew.jsp?tp=JOBNEWDETAIL&canedit=true&S1=<%=gen.gettable(data.get(s+ss)).trim()%>&S2=<%=gen.gettable(data.get(s+ss+1)).trim()%>"><%=gen.gettable(data.get(s+ss)).trim()%></a>
                                                            <%}else{
                                                                if(ss<7 || ss==10){
                                                                 out.print(gen.gettable(data.get(s+ss)).trim());
                                                                }else{
                                                                 out.print(gen.getNumberFormat(data.get(s+ss),0));
                                                                }
                                                            %>
                                                            
                                                            <%}%>
                                                            </td>
                                                        <%}%>
  													<td>
  														<div class="hidden-sm hidden-xs btn-group">
  															<button class="btn btn-xs btn-danger"  onclick="ondel('<%=gen.gettable(data.get(s)).trim()%>','<%=gen.gettable(data.get(s+1)).trim()%>')">
  																<i class="ace-icon fa fa-trash-o bigger-120"></i>
  															</button>
  														</div>                        
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
            
            function onact(Parm,Parm2){
                if(confirm("Data Closed?")){
                    location.href="jobnew.jsp?act=CLOSED&tp=<%=request.getParameter("tp")%>&S1="+Parm+"&S2="+Parm2;
                }
            }
            function ondel(Parm,Parm2){
                if(confirm("Delete Selected Record?","Delete")){
                    location.href="jobnew.jsp?act=DEL&Y10="+document.BGA.Y10.value+"&Y11="+document.BGA.Y11.value+"&Y12="+document.BGA.Y12.value+"&Y13="+document.BGA.Y13.value+"&Y1="+document.BGA.Y1.value+"&Y14="+document.BGA.Y14.value+"&tp=<%=request.getParameter("tp")%>&S1="+Parm+"&S2="+Parm2;
                }
            }
            function upload(){
        		location.href="upload.jsp?tp=UPLOADJOB";
        	}
            
		</script>
	</body>
</html>

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
            if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("DEL")){
                conn.setAutoCommit(false);
                if(msg.length()==0) msg=sgen.update(conn,"SALESDELETE",new String[]{Gen.gettable(request.getParameter("S1"))});
                if(msg.length()==0) msg=sgen.update(conn,"SALES1DELETE",new String[]{Gen.gettable(request.getParameter("S1"))});
                if(msg.length()==0) msg=sgen.update(conn,"SALES2DELETE",new String[]{Gen.gettable(request.getParameter("S1"))});
                if(msg.length()==0) msg=sgen.update(conn,"SALES3DELETE",new String[]{Gen.gettable(request.getParameter("S1"))});
                if(msg.length()==0) msg=sgen.update(conn,"SALES4DELETE",new String[]{Gen.gettable(request.getParameter("S1"))});
                if(msg.length()==0) msg=sgen.update(conn,"SALES5DELETE",new String[]{Gen.gettable(request.getParameter("S1"))});
                if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"SALESDELETE",gen.gettable(request.getParameter("S1"))+"|"});
                if(msg.length()>0){
                    conn.rollback();
                    msg="(Delete Data Failed!!"+msg+")";
                }else{
                    conn.commit();
                    msg="(Delete Data Successfully)";
                }
                
                conn.setAutoCommit(true);     
            }
        
         String[] judul=new String[]{"SALES ID","DATE","MEMBER ID","MEMBER NAME","CARD ID","REMARK","TOTAL SALES"};
         //[JobNo],[SalesCode],[TypeCode],[TrxDate],[BL],[Voyage],[vmst_customer.codedesc],[TotSalesAmt],[TotCostAmt],[TotProfit]
          String title="Sales";       
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
            String f1=gen.gettable(request.getParameter("Y10"));
            if(request.getParameter("Y10")==null){
                 f1=gen.getInt(gen.getToday("MM"))+"";
            }
            String f2=gen.gettable(request.getParameter("Y11"));
            if(f2.length()==0)f2=gen.getToday("yyyy");
            cond=new String[]{f1,f2};
            String tpx="SALESLIST1";
            String tpd="TREATMENTLIST1";
            if (gen.gettable(request.getParameter("ST1")).length()>0){
                tpx="SALESLIST7";
                tpd="TREATMENTLIST7";
                cond=new String[]{"%"+gen.gettable(request.getParameter("ST1"))+"%"};
                f1="";
                f2="";
            }else if (gen.gettable(request.getParameter("ST2")).length()>0){
                tpx="SALESLIST8";
                tpd="TREATMENTLIST8";
                cond=new String[]{"%"+gen.gettable(request.getParameter("ST2"))+"%"};
                f1="";
                f2="";
            }else if (gen.gettable(request.getParameter("ST3")).length()>0){
                tpx="SALESLIST9";
                tpd="TREATMENTLIST9";
                cond=new String[]{gen.gettable(request.getParameter("ST3"))};
                f1="";
                f2="";
            }else if (gen.gettable(request.getParameter("Y15")).length()>0){
                tpx="SALESLIST5";
                tpd="TREATMENTLIST5";
                cond=new String[]{gen.gettable(request.getParameter("Y15"))};
                f1="";
                f2="";
            }else if (gen.gettable(request.getParameter("Y14")).length()>0){
                tpx="SALESLIST6";
                tpd="TREATMENTLIST6";
                cond=new String[]{gen.gettable(request.getParameter("Y14"))};
                f1="";
                f2="";
            }else if(gen.gettable(request.getParameter("Y12")).length()>0 && gen.gettable(request.getParameter("Y13")).length()>0){
                tpx="SALESLIST4";
                tpd="TREATMENTLIST4";
                cond=new String[]{gen.gettable(request.getParameter("Y12")),gen.gettable(request.getParameter("Y13"))};
                f1="";
                f2="";
            }else if(gen.gettable(request.getParameter("Y12")).length()>0){
                tpx="SALESLIST2";
                tpd="TREATMENTLIST2";
                cond=new String[]{gen.gettable(request.getParameter("Y12"))};
                f1="";
                f2="";
            }else if(gen.gettable(request.getParameter("Y13")).length()>0){
                tpx="SALESLIST3";
                tpd="TREATMENTLIST3";
                cond=new String[]{gen.gettable(request.getParameter("Y13"))};
                f1="";
                f2="";
            }
            System.out.println(tpx);
        java.util.Vector data=sgen.getDataQuery(conn,tpx,cond);
        java.util.Vector datadetail=sgen.getDataQuery(conn,tpd,cond);
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
                						<form class="form-horizontal" name="BGA" method="POST" action="sales.jsp?tp=<%=tp%>" >
                                            <label class="control-label">Month:<select name="Y10" onchange="refresh();"><option></option><%for(int m=0;m<combo1.size();m++){%><option value="<%=gen.gettable(combo1.get(m)).trim()%>" <%if(f1.trim().equalsIgnoreCase(gen.gettable(combo1.get(m)).trim())) out.print("selected");%>><%=gen.gettable(combo1.get(m)).trim()%></option><%}%></select></label>
    										<label class="control-label">&nbsp;Year:<input type="text" id="Y11" maxlength="4" size="4" name="Y11" value="<%=f2%>"  placeholder="Year">  </label>
											<label class="control-label">&nbsp;Start Date:<input class="input-medium date-picker" name="Y12"  id="Y12" size="10" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(request.getParameter("Y12"))%>" placeholder="dd-mm-yyyy"  onchange="refresh();"/> </label>
											<label class="control-label">&nbsp;End Date:<input class="input-medium date-picker" name="Y13"  id="Y13" size="10"  type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(request.getParameter("Y13"))%>" placeholder="dd-mm-yyyy"  onchange="refresh();"/> </label>
											<label class="control-label">&nbsp;Sales No:<input type="text" id="Y14" maxlength="11" size="10" name="Y14"  placeholder="Sales No" value="<%=Gen.gettable(request.getParameter("Y14")).trim()%>" onchange="refresh();"/> </label>
											<label class="control-label">&nbsp;Member No:<input type="text" id="Y15" maxlength="11" size="12" name="Y15"  placeholder="Member No" value="<%=Gen.gettable(request.getParameter("Y15")).trim()%>" onchange="refresh();"/>
                                            <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('MEMBER','Y15','ST1','','')">
                                            <input type="text" name="ST1" size="25" maxlength="30" tabindex="4"  value="<%=Gen.gettable(request.getParameter("ST1")).trim()%>"  placeholder="Member Name" onchange="refresh();">
                                            <input type="text" name="ST2" size="15" maxlength="10" tabindex="5"  value="<%=Gen.gettable(request.getParameter("ST2")).trim()%>"  placeholder="Member Phone No" onchange="refresh();">
                                            <input type="text" id="ST3" name="ST3" size="10" maxlength="30" tabindex="6"  value="<%=Gen.gettable(request.getParameter("ST3")).trim()%>"  placeholder="Card No" onchange="refresh();" onblur="refresh();">
                                            <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('VOUCHER','ST3','','','')">
                                            &nbsp;&nbsp;<a href="javascript:jump()"><img title="Treatment" width=20 height=20 src=image/histmember.png ></a>
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
                                                    <td class="detail-col"><b>Details</td>
                                                   <%for(int s=0;s<judul.length;s++){
                                                            if(judul[s].length()==0)continue;
                                                        %>         
														<th><%=judul[s]%>&nbsp;
                                                        <%if(s==0){%><a href="salesdetail.jsp?add=true&tp=<%=request.getParameter("tp")%>"><img title="Add Sales" width=20 height=20 src=image/plus.gif></a>
                                                       <%}%>
                                                        </th>
                                                  <%}%>
                                                    <th>DELETE</th>
    											</tr>
											</thead>

											<tbody>
                                                   <%
                                                   int hic=1;
                                                   for(int s=0;s<data.size();s+=judul.length){%>         
												<tr>
  													<td class="center">
  														<div class="action-buttons">
  															<a href="#" class="green bigger-140 show-details-btn" title="Show Details">
  																<i class="ace-icon fa fa-angle-double-down"></i>
  																<span class="sr-only">Details</span>
  															</a>
  														</div>
  													</td>
                                                       <%for(int ss=0;ss<judul.length;ss++){
                                                            if(judul[ss].length()==0)continue;
                                                       %>
                                                            <td <%if(ss>=6) out.print("align=right");%>>
                                                            <%if(ss==0){%>
                                                            <a href="salesdetail.jsp?tp=SALES&canedit=true&S1=<%=gen.gettable(data.get(s+ss)).trim()%>"><%=gen.gettable(data.get(s+ss)).trim()%></a>
                                                            <%}else{
                                                                if(ss<6){
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
  															<button class="btn btn-xs btn-danger"  onclick="ondel('<%=gen.gettable(data.get(s)).trim()%>')">
  																<i class="ace-icon fa fa-trash-o bigger-120"></i>
  															</button>
  														</div>                        
  													</td>
                                                    
												</tr>
  												<tr class="detail-row">
  													<td colspan="10">
                                                        <table id="c-table" class="table table-striped table-bordered table-hover">
                      												<thead>
                      													<tr> 
                                                                              <td align=center><b>TREATMENT ID</td>
                                                                              <td  align=center><b>DATE</td>
                                                                              <td  align=center><b>CARD NAME</td>
                                                                              <td  align=center><b>REMARK</td>
                                                                              <td align=center><b>TOTAL TREATMENT</td>
                                                                        </tr>
                                                                    </thead>
                    												<tbody>
                                                                      <%for(int ii=0;ii<datadetail.size();ii+=10){
                                                                        if(Gen.gettable(data.get(s+2)).trim().equalsIgnoreCase(Gen.gettable(datadetail.get(ii+3)).trim())){%>
                                                  						<tr>
                                                  							<td nowrap>
                                                                            <a href="treatmentdetail.jsp?tp=TREATMENT&canedit=true&S1=<%=gen.gettable(datadetail.get(ii)).trim()%>"><%=gen.gettable(datadetail.get(ii)).trim()%></a></td>
                                                                            <td nowrap><%=Gen.gettable(datadetail.get(ii+1)).trim()%></td>
                                                                            <td nowrap><%=Gen.gettable(datadetail.get(ii+6)).trim()%></td>
                                                                             <td nowrap><%=Gen.gettable(datadetail.get(ii+7)).trim()%></td>
                                                                            <td align=right nowrap><%=Gen.getNumberFormat(datadetail.get(ii+8),0)%></td>
                                                      						</tr>
                                                                        <%}
                                                                        }%>    
                                                                    </tbody>
                                                                </table>    
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
	function setLink(Pdata,FieldName,FieldName2,cond,listinactive){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
            
            function jump(){
                    location.href="treatmentdetail.jsp?add=true&tp=<%=request.getParameter("tp")%>&T3="+document.BGA.Y15.value+"&ST3="+document.BGA.ST1.value+"&ST1="+document.BGA.ST3.value;
            }
            function ondel(Parm){
                if(confirm("Delete Selected Record?","Delete")){
                    location.href="sales.jsp?act=DEL&Y10="+document.BGA.Y10.value+"&Y11="+document.BGA.Y11.value+"&Y12="+document.BGA.Y12.value+"&Y13="+document.BGA.Y13.value+"&Y15="+document.BGA.Y15.value+"&Y14="+document.BGA.Y14.value+"&ST1="+document.BGA.ST1.value+"&ST2="+document.BGA.ST2.value+"&tp=<%=request.getParameter("tp")%>&S1="+Parm;
                }
            }
            function upload(){
        		location.href="upload.jsp?tp=UPLOADJOB";
        	}
            
		</script>
	</body>
    <%}%>
</html>

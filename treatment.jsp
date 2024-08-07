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
	   <jsp:include page="login.jsp"/>
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
                if(msg.length()==0) msg=sgen.update(conn,"UPDATEUSINGDATETREATMENT",new String[]{"",Gen.gettable(request.getParameter("S3")),Gen.gettable(request.getParameter("S4")),Gen.gettable(request.getParameter("S2")),Gen.gettable(request.getParameter("S2"))});
                if(msg.length()==0) msg=sgen.update(conn,"TREATMENT1DELETE",new String[]{Gen.gettable(request.getParameter("S1"))});
                if(msg.length()==0) msg=sgen.update(conn,"TREATMENT2DELETE",new String[]{Gen.gettable(request.getParameter("S1"))});
                if(msg.length()==0) msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"TREATMENTDELETE",gen.gettable(request.getParameter("S1"))+"|"});
                if(msg.length()>0){
                    conn.rollback();
                    msg="(Delete Data Failed!!"+msg+")";
                }else{
                    conn.commit();
                    msg="(Delete Data Successfully)";
                }
                
                conn.setAutoCommit(true);     
            }
         String[] judul=new String[]{"ID","DATE","SALES ID","MEMBER_ID","MEMBER NAME","CARD ID","CARD_NAME","REMARK","TOTAL TREATMENT","MATERIAL COST"};
         //[JobNo],[SalesCode],[TypeCode],[TrxDate],[BL],[Voyage],[vmst_customer.codedesc],[TotSalesAmt],[TotCostAmt],[TotProfit]
          String title="Treatment History";       
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
            String tpx="TREATMENTLIST1";
            if (gen.gettable(request.getParameter("ST1")).length()>0){//name
                tpx="TREATMENTLIST7";
                cond=new String[]{"%"+gen.gettable(request.getParameter("ST1"))+"%"};
                f1="";
                f2="";
            }else if (gen.gettable(request.getParameter("ST2")).length()>0){//name
                tpx="TREATMENTLIST8";
                cond=new String[]{"%"+gen.gettable(request.getParameter("ST2"))+"%"};
                f1="";
                f2="";
            }else if (gen.gettable(request.getParameter("Y15")).length()>0){//member id
                tpx="TREATMENTLIST5";
                cond=new String[]{gen.gettable(request.getParameter("Y15"))};
                f1="";
                f2="";
            }else if (gen.gettable(request.getParameter("Y14")).length()>0){//card
                tpx="TREATMENTLIST9";
                cond=new String[]{gen.gettable(request.getParameter("Y14"))};
                f1="";
                f2="";
            }else if(gen.gettable(request.getParameter("Y12")).length()>0 && gen.gettable(request.getParameter("Y13")).length()>0){
                tpx="TREATMENTLIST4";
                cond=new String[]{gen.gettable(request.getParameter("Y12")),gen.gettable(request.getParameter("Y13"))};
                f1="";
                f2="";
            }else if(gen.gettable(request.getParameter("Y12")).length()>0){
                tpx="TREATMENTLIST2";
                cond=new String[]{gen.gettable(request.getParameter("Y12"))};
                f1="";
                f2="";
            }else if(gen.gettable(request.getParameter("Y13")).length()>0){
                tpx="TREATMENTLIST3";
                cond=new String[]{gen.gettable(request.getParameter("Y13"))};
                f1="";
                f2="";
            }
            System.out.println(tpx);
        java.util.Vector data=sgen.getDataQuery(conn,tpx,cond);
        java.util.Vector datadetail=sgen.getDataQuery(conn,"TREATMENTDETAIL",new String[0]);
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
                						<form class="form-horizontal" name="BGA" method="POST" action="treatment.jsp?tp=<%=tp%>" >
                                            <label class="control-label">Month:<select name="Y10" onchange="refresh();"><option></option><%for(int m=0;m<combo1.size();m++){%><option value="<%=gen.gettable(combo1.get(m)).trim()%>" <%if(f1.trim().equalsIgnoreCase(gen.gettable(combo1.get(m)).trim())) out.print("selected");%>><%=gen.gettable(combo1.get(m)).trim()%></option><%}%></select></label>
    										<label class="control-label">&nbsp;Year:<input type="text" id="Y11" maxlength="4" size="4" name="Y11" value="<%=f2%>"  placeholder="Year">  </label>
											<label class="control-label">&nbsp;Start Date:<input class="input-medium date-picker" name="Y12"  id="Y12" size="10" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(request.getParameter("Y12"))%>" placeholder="dd-mm-yyyy"  onchange="refresh();"/> </label>
											<label class="control-label">&nbsp;End Date:<input class="input-medium date-picker" name="Y13"  id="Y13" size="10"  type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(request.getParameter("Y13"))%>" placeholder="dd-mm-yyyy"  onchange="refresh();"/> </label>
											<label class="control-label">&nbsp;Card No:<input type="text" id="Y14" maxlength="11" size="10" name="Y14"  placeholder="Card No" value="<%=Gen.gettable(request.getParameter("Y14")).trim()%>" onchange="refresh();"/> </label>
											<label class="control-label">&nbsp;Member Id:<input type="text" id="Y15" maxlength="11" size="12" name="Y15"  placeholder="Member No" value="<%=Gen.gettable(request.getParameter("Y15")).trim()%>" onchange="refresh();"/>
                                            <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('MEMBER','Y15','ST1','','')">
                                            <input type="text" name="ST1" size="45" maxlength="60" tabindex="4"  value="<%=Gen.gettable(request.getParameter("ST1")).trim()%>"  placeholder="Member Name" onchange="refresh();">
                                            &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:jup()"><img width=5% height=5% src="image/histmember.png" ></a>
                                            <input type="text" name="ST2" size="15" maxlength="15" tabindex="5"  value="<%=Gen.gettable(request.getParameter("ST2")).trim()%>"  placeholder="Member Phone No" onchange="refresh();">
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
														<th><%=judul[s]%>&nbsp;<%if(s==0){%><a href="javascript:jump()"><img width=20 height=20 src=image/plus.gif></a><%}%></th>
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
                                                            <td <%if(ss>=8) out.print("align=right");%> NOWRAP>
                                                            <%if(ss==0){%>
                                                            <a href="treatmentdetail.jsp?tp=TREATMENT&canedit=true&S1=<%=gen.gettable(data.get(s+ss)).trim()%>"><%=gen.gettable(data.get(s+ss)).trim()%></a>
                                                            <%}else{
                                                                if(ss<8){
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
                                                        <%if(gen.gettable(data.get(s+2)).trim().length()==0){%>
  															<button class="btn btn-xs btn-danger"  onclick="ondel('<%=gen.gettable(data.get(s)).trim()%>','<%=gen.gettable(data.get(s+1)).trim()%>','<%=gen.gettable(data.get(s+3)).trim()%>','<%=gen.gettable(data.get(s+5)).trim()%>')">
  																<i class="ace-icon fa fa-trash-o bigger-120"></i>
  															</button>
                                                        <%}%>    
  														</div>                        
  													</td>                                                   
												</tr>
  												<tr class="detail-row">
  													<td colspan="10">
                                                        <table id="c-table" class="table table-striped table-bordered table-hover">
                      												<thead>
                      													<tr> 
                                                                              <td  align=center><b>SEQ</td>
                                                                              <td align=center><b>TREATMENT</td>
                                                                              <td align=center><b>PERSONAL IN CHARGE</td>
                                                                              <td align=center><b>MATERIAL COST</td>
                                                                              <td align=center><b>PRICE</td>
                                                                        </tr>
                                                                    </thead>
                    												<tbody>
                                                                      <%for(int ii=0;ii<datadetail.size();ii+=8){
                                                                        if(Gen.gettable(data.get(s)).trim().equalsIgnoreCase(Gen.gettable(datadetail.get(ii)).trim())){%>
                                                  						<tr>
                                                  							<td nowrap><%=Gen.gettable(datadetail.get(ii+1)).trim()%></td>
                                                                            <td nowrap><%=Gen.gettable(datadetail.get(ii+3)).trim()%></td>
                                                                            <td nowrap><%=Gen.gettable(datadetail.get(ii+5)).trim()%></td>
                                                                            <td align=right nowrap><%=Gen.getNumberFormat(datadetail.get(ii+6),0)%></td>
                                                                            <td align=right nowrap><%=Gen.getNumberFormat(datadetail.get(ii+7),0)%></td>
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
            
            function ondel(Parm,Parm2,Parm3,Parm4){
                if(confirm("Delete Selected Record?","Delete")){
                    location.href="treatment.jsp?act=DEL&Y10="+document.BGA.Y10.value+"&Y11="+document.BGA.Y11.value+"&Y12="+document.BGA.Y12.value+"&Y13="+document.BGA.Y13.value+"&Y15="+document.BGA.Y15.value+"&Y14="+document.BGA.Y14.value+"&ST1="+document.BGA.ST1.value+"&ST2="+document.BGA.ST2.value+"&tp=<%=request.getParameter("tp")%>&S1="+Parm+"&S2="+Parm2+"&S3="+Parm3+"&S4="+Parm4;
                }
            }
	function jup(){
        if(document.BGA.Y15.value!=''){
             document.BGA.Y15.disabled=false;
    		url="history_treatment.jsp?tp=<%=request.getParameter("tp")%>&S1="+document.BGA.Y15.value;
    		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
             document.BGA.Y15.disabled=true;
        }else{
            alert("Fill The Member Id");
        }
	}
            function jump(){
                    location.href="treatmentdetail.jsp?add=true&tp=<%=request.getParameter("tp")%>&T3="+document.BGA.Y15.value+"&ST3="+document.BGA.ST1.value;
            }
            function upload(){
        		location.href="upload.jsp?tp=UPLOADJOB";
        	}
            
		</script>
	</body>
    <%}%>
</html>

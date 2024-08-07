<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta charset="utf-8" />
		<title>EstateAgency</title>

		<meta name="description" content="3 styles with inline editable feature" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />

		<!-- bootstrap & fontawesome -->
		<link rel="stylesheet" href="assets/css/bootstrap.min.css" />
		<link rel="stylesheet" href="assets/font-awesome/4.5.0/css/font-awesome.min.css" />

		<!-- page specific plugin styles -->
		<link rel="stylesheet" href="assets/css/jquery-ui.custom.min.css" />
		<link rel="stylesheet" href="assets/css/jquery.gritter.min.css" />
		<link rel="stylesheet" href="assets/css/select2.min.css" />
		<link rel="stylesheet" href="assets/css/bootstrap-datepicker3.min.css" />
		<link rel="stylesheet" href="assets/css/bootstrap-editable.min.css" />

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
        com.ysoft.General Gen = new com.ysoft.General();
        com.ysoft.General gen = new com.ysoft.General();  
        com.ysoft.subgeneral sgen = new com.ysoft.subgeneral();
        java.util.Enumeration enu = request.getParameterNames();
 	    while (enu.hasMoreElements()){
   		 	String pr =Gen.gettable(enu.nextElement());
      //      System.out.println(pr+"="+Gen.gettable(request.getParameter(pr)));
        }        

  		com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
      	java.sql.Connection conn = connMgr.getConnection("db2");
         java.util.Vector vks=(java.util.Vector)ses.getAttribute("User");    
        String msg="";
        if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){
        //,T1,T3,T2,T4,T5,T6,T7,T9,T10,T12,T13,T11
//name=?,sex=?,birthdate=?,idno=?,emailaddr=?,hpno=?,wano=?,Addr=?,moto=?,[BankId]=?,[AccountId]=?,[AccountName]=?
          msg=sgen.update(conn,"AGENUPDATE",new String[]{gen.gettable(request.getParameter("T1")),gen.gettable(request.getParameter("T3")),gen.gettable(request.getParameter("T2")),gen.gettable(request.getParameter("T4")),gen.gettable(request.getParameter("T5")),gen.gettable(request.getParameter("T6")),gen.gettable(request.getParameter("T7")),gen.gettable(request.getParameter("T9")),gen.gettable(request.getParameter("T10")),gen.gettable(request.getParameter("T12")),gen.gettable(request.getParameter("T13")),gen.gettable(request.getParameter("T11")),gen.gettable(request.getParameter("Y11"))});
          msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{sgen.getUserId(vks),"AGENUPDATE",gen.gettable(request.getParameter("Y11"))});          
          if(msg.length()>0){
              msg="(Save Failed!!"+msg+")";
          }     
        }
        
        if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Upload")){
            msg=sgen.upload(conn,request);
            msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{sgen.getUserId(vks),"AGENUPLOAD",gen.gettable(request.getParameter("Y11"))});
        }
        
        String[] cond=new String[]{Gen.gettable(request.getParameter("Y11"))};
        
        java.util.Vector memb=sgen.getDataQuery(conn,"CUSTMST",new String[0]);//userid,name,idimage,wano,hpno,moto,JoinDate,IdNo,emailaddr
        if(!sgen.getUserType(vks).equalsIgnoreCase("U")){
            memb=sgen.getDataQuery(conn,"CUSTMSTBYAGEN",new String[]{sgen.getUserId(vks)});
        }
        java.util.Vector vk=sgen.getDataQuery(conn,"CUSTDETAIL",cond);
        
        java.util.Vector vkp=sgen.getDataQuery(conn,"CUSTPROP",cond);
        java.util.Vector foto=sgen.getDataQuery(conn,"CUSTPROPERTYFOTO",cond);
        java.util.Vector pay=sgen.getDataQuery(conn,"CUSTHISTBANK",cond);
          connMgr.freeConnection("db2", conn);
          connMgr.release();
        String view="";
%>

	<body class="no-skin">
        <jsp:include page="menu.jsp" flush ="true"/>
			<div class="main-content">
				<div class="main-content-inner">
					<div class="page-content">
						<div class="page-header">
							<h1>
								Pelanggan <%=msg%>
							</h1>
						</div><!-- /.page-header -->
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
								<div>
									<div id="user-profile-2" class="user-profile row">
                                        <div class="col-sm-offset-1 col-sm-10">
											<form class="form-horizontal" name="BS" method="POST" action="pelanggan.jsp" >
											<div class="form-group">
												<label class="col-sm-3 control-label no-padding-right">Pelanggan</label>
												<div class="col-sm-9">
														<div class="input-medium">
															<div  class="input-group">
    															<select class="form-control" name="Y11" onchange="refresh();">
                                                                    <option></option>
                                                                <%for(int ms=0;ms<memb.size();ms+=2){%>
                                                                	<option value="<%=Gen.gettable(memb.get(ms)).trim()%>" <%if(Gen.gettable(request.getParameter("Y11")).trim().equalsIgnoreCase(Gen.gettable(memb.get(ms)).trim())) out.print("selected");%>><%=Gen.gettable(memb.get(ms+1)).trim()%>(<%=Gen.gettable(memb.get(ms)).trim()%>)</option>
                                                                <%}%>
                                                                </select>    
															</div>
														</div>
												</div>
											</div>
                                            <input type="hidden" name="tp" value="<%=Gen.gettable(request.getParameter("tp"))%>">
                                            <input type="hidden" name="act" value="">
                                            </form>
                                    </div>
                                 </div>
                               </div>
                             </div>
                          </div>
<%if(Gen.gettable(request.getParameter("Y11")).trim().length()>0){%>
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
								<div>
									<div id="user-profile-3" class="user-profile row">
										<div class="col-sm-offset-1 col-sm-10">
											<form class="form-horizontal" name="BGA" method="POST" action="pelanggan.jsp" >
												<div class="tabbable">
													<ul class="nav nav-tabs padding-16">
														<li class="active">
															<a data-toggle="tab" href="#edit-basic">
																<i class="green ace-icon fa fa-pencil-square-o bigger-125"></i>
																Profil
															</a>
														</li>
														<li>
															<a data-toggle="tab" href="#edit-properti">
																<i class="blue ace-icon fa fa-file-o bigger-125"></i>
																Properti
															</a>
														</li>
														<li>
															<a data-toggle="tab" href="#edit-transfer">
																<i class="blue ace-icon fa fa-file-o bigger-125"></i>
																Bukti Bank
															</a>
														</li>
													</ul>

													<div class="tab-content profile-edit-tab-content">
														<div id="edit-basic" class="tab-pane in active">
															<h4 class="header blue bolder smaller">Umum</h4>

															<div class="row">
																<div class="col-xs-12 col-sm-4">
            													<a href="dropzone.jsp?fr=G&Y11=<%=Gen.gettable(request.getParameter("Y11")).trim()%>&tp=PELANGGAN"><img width=150 height=200 src=dokument/<%=Gen.gettable(vk.get(11)).trim()%>></a>
																</div>
																<div class="vspace-12-sm"></div>
																<div class="col-xs-12 col-sm-8">
																	<div class="form-group">
																		<label class="col-sm-4 control-label no-padding-right" for="form-field-username">Id Pelanggan</label>

																		<div class="col-sm-8">
																		<label class="control-label"><b><%=gen.gettable(request.getParameter("Y11")).trim()%></B></label>
                                                                        	<input type="hidden" name="T8" value="<%=gen.gettable(request.getParameter("Y11")).trim()%>" />
																		</div>
																	</div>

																	<div class="space-4"></div>

																	<div class="form-group">
																		<label class="col-sm-4 control-label no-padding-right" for="form-field-first">*Nama</label>

																		<div class="col-sm-8">
																			<input class="col-xs-12 col-sm-20" type="text" id="form-field-first" maxlength="60" name="T1"  placeholder="Nama Lengkap" value="<%=Gen.gettable(vk.get(1)).trim()%>" <%=view%>/>
																		</div>
																	</div>
																	<div class="space-4"></div>

																	<div class="form-group">
																		<label class="col-sm-4 control-label no-padding-right">Tanggal Daftar</label>

																		<div class="col-sm-8">
																			<label class="control-label"><b><%=gen.gettable(vk.get(12)).trim()%></b></label>
																		</div>
																	</div>
																	<div class="space-4"></div>

																	<div class="form-group">
																		<div class="col-sm-8" align=center>
																			<a href="dropzone.jsp?fr=K&Y11=<%=Gen.gettable(request.getParameter("Y11")).trim()%>&tp=PELANGGAN"><img width=140 height=100 src=dokument/<%=Gen.gettable(vk.get(10)).trim()%>></a>
																		</div>
																	</div>
            													
																</div>
															</div>
															<hr />
															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right" >Tanggal Lahir</label>

																<div class="col-sm-9">
																	<div class="input-medium">
																		<div class="input-group">
																			<input class="input-medium date-picker" name="T2"  id="form-field-date" type="text" data-date-format="dd-mm-yyyy" value="<%=gen.gettable(vk.get(3)).trim()%>" placeholder="dd-mm-yyyy" <%=view%>/>
																			<span class="input-group-addon">
																				<i class="ace-icon fa fa-calendar"></i>
																			</span>
																		</div>
																	</div>
																</div>
															</div>

															<div class="space-4"></div>

															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right">Jenis Kelamin</label>

																<div class="col-sm-9">
																	<label class="inline">
																		<input name="form-field-gender" type="radio" <%if(gen.gettable(vk.get(2)).trim().equalsIgnoreCase("M")) out.print("checked");%> onclick="setradiogender('M')" class="ace" <%=view%>/>
																		<span class="lbl middle"> Laki-laki</span>
																	</label>
                                                                    <input type="hidden" name="T3" value="<%=gen.gettable(vk.get(2)).trim()%>">
																	&nbsp; &nbsp; &nbsp;
																	<label class="inline">
																		<input name="form-field-gender" type="radio"  <%if(gen.gettable(vk.get(2)).trim().equalsIgnoreCase("F")) out.print("checked");%> onclick="setradiogender('F')"  class="ace" <%=view%>/>
																		<span class="lbl middle"> Perempuan</span>
																	</label>
																</div>
															</div>

															<div class="space-4"></div>
															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right ">No. KTP</label>

																<div class="col-sm-9">
																	<label class="inline">
                                                                        <input size="30" type="text" id="form-field-moto" maxlength="30" name="T4"  placeholder="No KTP" value="<%=gen.gettable(vk.get(4)).trim()%>" />
																	</label>
																</div>
															</div>
															<div class="space"></div>
															<h4 class="header blue bolder smaller">Informasi Kontak</h4>

															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right" for="form-field-email">Email</label>

																<div class="col-sm-9">
																	<span class="input-icon input-icon-right">
																		<input type="email" id="form-field-email" name="T5" value="<%=gen.gettable(vk.get(5)).trim()%>" <%=view%>/>
																		<i class="ace-icon fa fa-envelope"></i>
																	</span>
																</div>
															</div>


															<div class="space-4"></div>

															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right" for="form-field-phone">*No Telp/Hp</label>

																<div class="col-sm-9">
																	<span class="input-icon input-icon-right">
																		<input class="col-xs-12 col-sm-20  input-mask-phone" name="T6" type="text" id="form-field-phone" value="<%=gen.gettable(vk.get(6)).trim()%>" <%=view%>/>
																		<i class="ace-icon fa fa-phone fa-flip-horizontal"></i>
																	</span>
																</div>
															</div>

															<div class="space-4"></div>

															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right" for="form-field-phone">No. WA</label>

																<div class="col-sm-9">
																	<span class="input-icon input-icon-right">
																		<input class="col-xs-12 col-sm-20 input-mask-phone" name="T7" type="text" id="form-field-wa" value="<%=gen.gettable(vk.get(7)).trim()%>" <%=view%>/>
																		<i class="ace-icon fa fa-phone fa-flip-horizontal"></i>
																	</span>
																</div>
															</div>
                                                            <div class="space-4"></div>
															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right" for="form-field-email">Alamat</label>

																<div class="col-sm-9">
																	<span class="input-icon input-icon-right">
																		<input type="text" id="T9" name="T9" maxlength="100" size="100" value="<%=gen.gettable(vk.get(8)).trim()%>" <%=view%>/>
																	</span>
																</div>
															</div>
															<div class="space"></div>
															<h4 class="header blue bolder smaller">Informasi Bank</h4>

															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right" for="form-field-bank">Nama Bank</label>

																<div class="col-sm-9">
																	<span class="input-icon input-icon-right">
																		<input type="text" id="form-field-bank" name="T12" value="<%=gen.gettable(vk.get(13))%>" />
																	</span>
																</div>
															</div>


															<div class="space-4"></div>

															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right" for="T13">No Rekening</label>

																<div class="col-sm-9">
																	<span class="input-icon input-icon-right">
																		<input type="text" id="T13" maxlength=20 size=20 name="T13" value="<%=gen.gettable(vk.get(14))%>" />
																	</span>
																</div>
															</div>

															<div class="space-4"></div>

															<div class="form-group">
																<label class="col-sm-3 control-label no-padding-right" for="T11">Nama Rekening</label>

																<div class="col-sm-9">
																	<span class="input-icon input-icon-right">
																		<input type="text" id="T11" maxlength=60 size=60  name="T11" value="<%=gen.gettable(vk.get(15)).trim()%>" />
																	</span>
																</div>
															</div>
                                                            <div class="space-4"></div>
            												<div class="clearfix form-actions">
            													<div class="col-md-offset-3 col-md-9">
            														<button class="btn btn-info" type="button" onclick="setsave();">
            															<i class="ace-icon fa fa-check bigger-110"></i>
            															Save
            														</button>
            													</div>
            												</div>

														</div>
														<div id="edit-properti" class="tab-pane">
                                                            <table id="simple-table" class="table  table-bordered table-hover">
                											<!--<table id="dynamic-table" class="table table-striped table-bordered table-hover">-->
                												<thead>
                													<tr>
                                                                        <th class="detail-col">Details</th>
                                                                        <th>Id Properti</th>
                                                                        <th>Tanggal Transaksi</th>
                                                                        <th>Jenis Properti</th>
                                                                        <th>Lokasi</th>
                                                                        <th>Nama/Alamat</th>
                                                                        <th>Agen</th>
                                                                        <%if(sgen.getUserType(vks).equalsIgnoreCase("U")){%>
                                                                        <th>Delete</th>
                                                                        <%}%>
                													</tr>
                												</thead>
                
                												<tbody>
                                                                    <%for(int i=0;i<vkp.size();i+=7){%>
                                                						<tr>
                        													<td class="center">
                        														<div class="action-buttons">
                        															<a href="#" class="green bigger-140 show-details-btn" title="Show Details">
                        																<i class="ace-icon fa fa-angle-double-down"></i>
                        																<span class="sr-only">Details</span>
                        															</a>
                        														</div>
                        													</td>
                                                                        
                                                							<td><A HREF="javascript:jumpprop('<%=Gen.gettable(vkp.get(i)).trim()%>')"><%=Gen.gettable(vkp.get(i))%></a></td>
                                                                            <td><%=Gen.gettable(vkp.get(i+6))%></td>
                                                							<td ><%=Gen.gettable(vkp.get(i+1))%></td>
                                                							<td><%=Gen.gettable(vkp.get(i+2))%></td>
                                                                            <td><%=Gen.gettable(vkp.get(i+3))%></td>
                                                							<td><A HREF="javascript:jump('<%=Gen.gettable(vkp.get(i+5)).trim()%>')"><%=Gen.gettable(vkp.get(i+4))%></a></td>
                                                                            <%if(sgen.getUserType(vks).equalsIgnoreCase("U")){%>
                        													<td>
                        														<div class="hidden-sm hidden-xs btn-group">
                        															<button class="btn btn-xs btn-danger"  onclick="ondel('<%=gen.gettable(vkp.get(i)).trim()%>')">
                        																<i class="ace-icon fa fa-trash-o bigger-120"></i>
                        															</button>
                        														</div>                        
                        													</td>
                                                                             <%}%>
                                                                            
                                                   						</tr>
                          												<tr class="detail-row">
                          													<td  colspan="5">
                                            											<table id="c-table" class="table table-striped table-bordered table-hover">
                                            												<tbody>
                                                                          						<tr>
                                                                                              <%for(int ii=0;ii<foto.size();ii+=2){
                                                                                                if(Gen.gettable(vkp.get(i)).trim().equalsIgnoreCase(Gen.gettable(foto.get(ii)).trim())){
                                                                                              %>
                                                                          							<td><img width=100 height=100 src=img/<%=Gen.gettable(foto.get(ii+1)).trim()%>></td>
                                                                                                <%}
                                                                                                }%>    
                                                                              						</tr>
                                                                                            </tbody>
                                                                                </table>    
                          													</td>
                          												</tr>                                                                            
                                                                    <%}%>
                												</tbody>
                											</table>
														</div>
                                                        <div id="edit-transfer" class="tab-pane">
                                                            <table id="simple-table" class="table  table-bordered table-hover">
                											<!--<table id="dynamic-table" class="table table-striped table-bordered table-hover">-->
                												<thead>
                													<tr>
                                                                        <th>No. Referensi</th>
                                                                        <th>Tanggal</th>
                                                                        <th>Status</th>
                                                                        <th>Debit</th>
                                                                        <th>Kredit</th>
                                                                        <th>Keterangan</th>
                													</tr>
                												</thead>
                
                												<tbody>
                                                                    <%for(int i=0;i<pay.size();i+=6){%>
                                                						<tr>
                                                							<td><%=Gen.gettable(pay.get(i))%></td>
                                                							<td ><%=Gen.gettable(pay.get(i+1))%></td>
                                                							<td><%=Gen.gettable(pay.get(i+2))%></td>
                                                                            <td align=right><%=Gen.getNumberFormat(pay.get(i+3),0)%></td>
                                                                            <td align=right><%=Gen.getNumberFormat(pay.get(i+4),0)%></td>
                                                                            <td ><%=Gen.gettable(pay.get(i+5))%></td>
                                                   						</tr>
                                                                    <%}%>
                												</tbody>
                											</table>
														</div>
													</div>
												</div>
                                                <input type="hidden" name="act" value="">
                                                <input type="hidden" name="Y11" value="<%=request.getParameter("Y11")%>">
                                                <input type="hidden" name="Y12" value="">
                                                <input type="hidden" name="tp" value="PELANGGAN">
											</form>
										</div><!-- /.span -->
									</div><!-- /.user-profile -->
								</div>

								<!-- PAGE CONTENT ENDS -->
							</div><!-- /.col -->
						</div><!-- /.row -->
        <%}%>
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

		<!--[if lte IE 8]>
		  <script src="assets/js/excanvas.min.js"></script>
		<![endif]-->
		<script src="assets/js/jquery-ui.custom.min.js"></script>
		<script src="assets/js/jquery.ui.touch-punch.min.js"></script>
		<script src="assets/js/jquery.gritter.min.js"></script>
		<script src="assets/js/bootbox.js"></script>
		<script src="assets/js/jquery.easypiechart.min.js"></script>
		<script src="assets/js/bootstrap-datepicker.min.js"></script>
		<script src="assets/js/jquery.hotkeys.index.min.js"></script>
		<script src="assets/js/bootstrap-wysiwyg.min.js"></script>
		<script src="assets/js/select2.min.js"></script>
		<script src="assets/js/spinbox.min.js"></script>
		<script src="assets/js/bootstrap-editable.min.js"></script>
		<script src="assets/js/ace-editable.min.js"></script>
		<script src="assets/js/jquery.maskedinput.min.js"></script>

		<!-- ace scripts -->
		<script src="assets/js/ace-elements.min.js"></script>
		<script src="assets/js/ace.min.js"></script>

		<!-- inline scripts related to this page -->
		<script type="text/javascript">
	function setradiogender(avalue)
	{
  		document.BGA.T3.value = avalue;
        
	}
    function ondel(Parm){
        if(confirm("Delete Selected Record?","Delete")){
           document.BGA.act.value="DEL";
           document.BGA.Y12.value=Parm;
            BGA.submit();
        }
    }
    
	function setradiodonasi(avalue)
	{
  		document.BGA.T4.value = avalue;
        
	}
	function jumpprop(Parm){
		window.open("properti.jsp?view=disabled&Y11="+Parm,"","toolbar=yes,menubar=yes,resizable=1,scrollbars=1");
	}
	function jump(Parm){
		window.open("pemakaidetail.jsp?view=disabled&tp=A&Y11="+Parm,"","toolbar=yes,menubar=yes,resizable=1,scrollbars=1");
	}
            function  setsave(){
            
                  if(document.BGA.T1.value==""){
                      alert("Please Fill The Name");
                  }else if(document.BGA.T6.value==""){
                      alert("Please Fill The Phone No");
                  }else{
                     document.BGA.act.value="Save";
                      BGA.submit();
                  }
            }
           function xf(){
                    location.href="dropzone.jsp?Y11=<%=Gen.gettable(request.getParameter("Y11"))%>&tp=VIEWDONATUR&fr=T";
            }
            function  refresh(){                
                     document.BS.act.value="Filter";
                      BS.submit();
            }
			jQuery(function($) {
			
				var active_class = 'active';
				//editables on first profile page
				$.fn.editable.defaults.mode = 'inline';
				$.fn.editableform.loading = "<div class='editableform-loading'><i class='ace-icon fa fa-spinner fa-spin fa-2x light-blue'></i></div>";
			    $.fn.editableform.buttons = '<button type="submit" class="btn btn-info editable-submit"><i class="ace-icon fa fa-check"></i></button>'+
			                                '<button type="button" class="btn editable-cancel"><i class="ace-icon fa fa-times"></i></button>';    
				
				//editables 
				
				//text editable
			    $('#username')
				.editable({
					type: 'text',
					name: 'username'		
			    });
			
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
				$('#user-profile-3')
				.find('input[type=file]').ace_file_input({
					style:'well',
					btn_choose:'Change avatar',
					btn_change:null,
					no_icon:'ace-icon fa fa-picture-o',
					thumbnail:'large',
					droppable:true,
					
					allowExt: ['jpg', 'jpeg', 'png', 'gif'],
					allowMime: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
				})
				.end().find('button[type=reset]').on(ace.click_event, function(){
					$('#user-profile-3 input[type=file]').ace_file_input('reset_input');
				})
				.end().find('.date-picker').datepicker().next().on(ace.click_event, function(){
					$(this).prev().focus();
				});
			
			
				$('#user-profile-3').find('input[type=file]').ace_file_input('show_file_list', [{type: 'image', name: $('#avatar').attr('src')}]);
			
			
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
				
				//select2 editable
				var countries = [];
			    $.each({ "CA": "Canada", "IN": "India", "NL": "Netherlands", "TR": "Turkey", "US": "United States"}, function(k, v) {
			        countries.push({id: k, text: v});
			    });
			
				var cities = [];
				cities["CA"] = [];
				$.each(["Toronto", "Ottawa", "Calgary", "Vancouver"] , function(k, v){
					cities["CA"].push({id: v, text: v});
				});
				cities["IN"] = [];
				$.each(["Delhi", "Mumbai", "Bangalore"] , function(k, v){
					cities["IN"].push({id: v, text: v});
				});
				cities["NL"] = [];
				$.each(["Amsterdam", "Rotterdam", "The Hague"] , function(k, v){
					cities["NL"].push({id: v, text: v});
				});
				cities["TR"] = [];
				$.each(["Ankara", "Istanbul", "Izmir"] , function(k, v){
					cities["TR"].push({id: v, text: v});
				});
				cities["US"] = [];
				$.each(["New York", "Miami", "Los Angeles", "Chicago", "Wysconsin"] , function(k, v){
					cities["US"].push({id: v, text: v});
				});
				
				var currentValue = "NL";
                $('#example').DataTable();
			    $('#country').editable({
					type: 'select2',
					value : 'NL',
					//onblur:'ignore',
			        source: countries,
					select2: {
						'width': 140
					},		
					success: function(response, newValue) {
						if(currentValue == newValue) return;
						currentValue = newValue;
						
						var new_source = (!newValue || newValue == "") ? [] : cities[newValue];
						
						//the destroy method is causing errors in x-editable v1.4.6+
						//it worked fine in v1.4.5
						/**			
						$('#city').editable('destroy').editable({
							type: 'select2',
							source: new_source
						}).editable('setValue', null);
						*/
						
						//so we remove it altogether and create a new element
						var city = $('#city').removeAttr('id').get(0);
						$(city).clone().attr('id', 'city').text('Select City').editable({
							type: 'select2',
							value : null,
							//onblur:'ignore',
							source: new_source,
							select2: {
								'width': 140
							}
						}).insertAfter(city);//insert it after previous instance
						$(city).remove();//remove previous instance
						
					}
			    });
			
				$('#city').editable({
					type: 'select2',
					value : 'Amsterdam',
					//onblur:'ignore',
			        source: cities[currentValue],
					select2: {
						'width': 140
					}
			    });
			
			
				
				//custom date editable
				$('#signup').editable({
					type: 'adate',
					date: {
						//datepicker plugin options
						    format: 'yyyy/mm/dd',
						viewformat: 'yyyy/mm/dd',
						 weekStart: 1
						 
						//,nativeUI: true//if true and browser support input[type=date], native browser control will be used
						//,format: 'yyyy-mm-dd',
						//viewformat: 'yyyy-mm-dd'
					}
				})
			
			    $('#age').editable({
			        type: 'spinner',
					name : 'age',
					spinner : {
						min : 16,
						max : 99,
						step: 1,
						on_sides: true
						//,nativeUI: true//if true and browser support input[type=number], native browser control will be used
					}
				});
				
			
			    $('#login').editable({
			        type: 'slider',
					name : 'login',
					
					slider : {
						 min : 1,
						  max: 50,
						width: 100
						//,nativeUI: true//if true and browser support input[type=range], native browser control will be used
					},
					success: function(response, newValue) {
						if(parseInt(newValue) == 1)
							$(this).html(newValue + " hour ago");
						else $(this).html(newValue + " hours ago");
					}
				});
			
				$('#about').editable({
					mode: 'inline',
			        type: 'wysiwyg',
					name : 'about',
			
					wysiwyg : {
						//css : {'max-width':'300px'}
					},
					success: function(response, newValue) {
					}
				});
				
				
				
				// *** editable avatar *** //
				try {//ie8 throws some harmless exceptions, so let's catch'em
			
					//first let's add a fake appendChild method for Image element for browsers that have a problem with this
					//because editable plugin calls appendChild, and it causes errors on IE at unpredicted points
					try {
						document.createElement('IMG').appendChild(document.createElement('B'));
					} catch(e) {
						Image.prototype.appendChild = function(el){}
					}
			
					var last_gritter
					$('#avatar').editable({
						type: 'image',
						name: 'avatar',
						value: null,
						//onblur: 'ignore',  //don't reset or hide editable onblur?!
						image: {
							//specify ace file input plugin's options here
							btn_choose: 'Change Avatar',
							droppable: true,
							maxSize: 110000,//~100Kb
			
							//and a few extra ones here
							name: 'avatar',//put the field name here as well, will be used inside the custom plugin
							on_error : function(error_type) {//on_error function will be called when the selected file has a problem
								if(last_gritter) $.gritter.remove(last_gritter);
								if(error_type == 1) {//file format error
									last_gritter = $.gritter.add({
										title: 'File is not an image!',
										text: 'Please choose a jpg|gif|png image!',
										class_name: 'gritter-error gritter-center'
									});
								} else if(error_type == 2) {//file size rror
									last_gritter = $.gritter.add({
										title: 'File too big!',
										text: 'Image size should not exceed 100Kb!',
										class_name: 'gritter-error gritter-center'
									});
								}
								else {//other error
								}
							},
							on_success : function() {
								$.gritter.removeAll();
							}
						},
					    url: function(params) {
							// ***UPDATE AVATAR HERE*** //
							//for a working upload example you can replace the contents of this function with 
							//examples/profile-avatar-update.js
			
							var deferred = new $.Deferred
			
							var value = $('#avatar').next().find('input[type=hidden]:eq(0)').val();
							if(!value || value.length == 0) {
								deferred.resolve();
								return deferred.promise();
							}
			
			
							//dummy upload
							setTimeout(function(){
								if("FileReader" in window) {
									//for browsers that have a thumbnail of selected image
									var thumb = $('#avatar').next().find('img').data('thumb');
									if(thumb) $('#avatar').get(0).src = thumb;
								}
								
								deferred.resolve({'status':'OK'});
			
								if(last_gritter) $.gritter.remove(last_gritter);
								last_gritter = $.gritter.add({
									title: 'Avatar Updated!',
									text: 'Uploading to server can be easily implemented. A working example is included with the template.',
									class_name: 'gritter-info gritter-center'
								});
								
							 } , parseInt(Math.random() * 800 + 800))
			
							return deferred.promise();
							
							// ***END OF UPDATE AVATAR HERE*** //
						},
						
						success: function(response, newValue) {
						}
					})
				}catch(e) {}
				
				/**
				//let's display edit mode by default?
				var blank_image = true;//somehow you determine if image is initially blank or not, or you just want to display file input at first
				if(blank_image) {
					$('#avatar').editable('show').on('hidden', function(e, reason) {
						if(reason == 'onblur') {
							$('#avatar').editable('show');
							return;
						}
						$('#avatar').off('hidden');
					})
				}
				*/
			
				//another option is using modals
				$('#avatar2').on('click', function(){
					var modal = 
					'<div class="modal fade">\
					  <div class="modal-dialog">\
					   <div class="modal-content">\
						<div class="modal-header">\
							<button type="button" class="close" data-dismiss="modal">&times;</button>\
							<h4 class="blue">Change Avatar</h4>\
						</div>\
						\
						<form class="no-margin">\
						 <div class="modal-body">\
							<div class="space-4"></div>\
							<div style="width:75%;margin-left:12%;"><input type="file" name="file-input" /></div>\
						 </div>\
						\
						 <div class="modal-footer center">\
							<button type="submit" class="btn btn-sm btn-success"><i class="ace-icon fa fa-check"></i> Submit</button>\
							<button type="button" class="btn btn-sm" data-dismiss="modal"><i class="ace-icon fa fa-times"></i> Cancel</button>\
						 </div>\
						</form>\
					  </div>\
					 </div>\
					</div>';
					
					
					var modal = $(modal);
					modal.modal("show").on("hidden", function(){
						modal.remove();
					});
			
					var working = false;
			
					var form = modal.find('form:eq(0)');
					var file = form.find('input[type=file]').eq(0);
					file.ace_file_input({
						style:'well',
						btn_choose:'Click to choose new avatar',
						btn_change:null,
						no_icon:'ace-icon fa fa-picture-o',
						thumbnail:'small',
						before_remove: function() {
							//don't remove/reset files while being uploaded
							return !working;
						},
						allowExt: ['jpg', 'jpeg', 'png', 'gif'],
						allowMime: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
					});
			
					form.on('submit', function(){
						if(!file.data('ace_input_files')) return false;
						
						file.ace_file_input('disable');
						form.find('button').attr('disabled', 'disabled');
						form.find('.modal-body').append("<div class='center'><i class='ace-icon fa fa-spinner fa-spin bigger-150 orange'></i></div>");
						
						var deferred = new $.Deferred;
						working = true;
						deferred.done(function() {
							form.find('button').removeAttr('disabled');
							form.find('input[type=file]').ace_file_input('enable');
							form.find('.modal-body > :last-child').remove();
							
							modal.modal("hide");
			
							var thumb = file.next().find('img').data('thumb');
							if(thumb) $('#avatar2').get(0).src = thumb;
			
							working = false;
						});
						
						
						setTimeout(function(){
							deferred.resolve();
						} , parseInt(Math.random() * 800 + 800));
			
						return false;
					});
							
				});
			
				
			
				//////////////////////////////
				$('#profile-feed-1').ace_scroll({
					height: '250px',
					mouseWheelLock: true,
					alwaysVisible : true
				});
			
				$('a[ data-original-title]').tooltip();
			
				$('.easy-pie-chart.percentage').each(function(){
				var barColor = $(this).data('color') || '#555';
				var trackColor = '#E2E2E2';
				var size = parseInt($(this).data('size')) || 72;
				$(this).easyPieChart({
					barColor: barColor,
					trackColor: trackColor,
					scaleColor: false,
					lineCap: 'butt',
					lineWidth: parseInt(size/10),
					animate:false,
					size: size
				}).css('color', barColor);
				});
			  
				///////////////////////////////////////////
			
				//right & left position
				//show the user info on right or left depending on its position
				$('#user-profile-2 .memberdiv').on('mouseenter touchstart', function(){
					var $this = $(this);
					var $parent = $this.closest('.tab-pane');
			
					var off1 = $parent.offset();
					var w1 = $parent.width();
			
					var off2 = $this.offset();
					var w2 = $this.width();
			
					var place = 'left';
					if( parseInt(off2.left) < parseInt(off1.left) + parseInt(w1 / 2) ) place = 'right';
					
					$this.find('.popover').removeClass('right left').addClass(place);
				}).on('click', function(e) {
					e.preventDefault();
				});
			
			
				///////////////////////////////////////////
			
				////////////////////
				//change profile
				$('[data-toggle="buttons"] .btn').on('click', function(e){
					var target = $(this).find('input[type=radio]');
					var which = parseInt(target.val());
					$('.user-profile').parent().addClass('hide');
					$('#user-profile-'+which).parent().removeClass('hide');
				});
				
				
				
				/////////////////////////////////////
				$(document).one('ajaxloadstart.page', function(e) {
					//in ajax mode, remove remaining elements before leaving page
					try {
						$('.editable').editable('destroy');
					} catch(e) {}
					$('[class*=select2]').remove();
				});
			});
		</script>
	</body>
</html>

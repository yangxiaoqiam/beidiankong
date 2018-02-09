<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.whir.ezoffice.portal.bd.*"%>
<%@ page import="com.whir.ezoffice.portal.po.*"%>
<%@ page import="com.whir.ezoffice.portal.vo.*"%>
<%@ page import="com.whir.ezoffice.portal.cache.*"%>
<%@ page import="com.whir.ezoffice.portal.common.util.*"%>
<%@ page import="com.whir.common.util.CommonUtils"%>
<%@ page import="com.whir.ezoffice.customize.customermenu.bd.*"%>
<%@ page import="com.whir.ezoffice.customdb.customdb.actionsupport.*"%>
<%
ConfMap confMap = (ConfMap)request.getAttribute("confMap");
String outter = request.getParameter("outter");
String portalType = request.getParameter("portalType");
String limitNum = confMap.get("limitNum");
String limitChar = ( confMap.get("limitChar")==null || "".equals(confMap.get("limitChar")) ) ? "12" : confMap.get("limitChar");
String titleType = confMap.get("titleType");
//自定义模块classId: 模块Id|表单formId|数据表Id 如123|456|789
String classId = confMap.get("classId");
//显示样式，新信息提醒时限
String displayType = confMap.get("displayType")!=null && !"".equals(confMap.get("displayType")) ? confMap.get("displayType") : "0"; //默认表格样式
String newInfoRemindDays = confMap.get("newInfoRemindDays")!=null&&!"".equals(confMap.get("newInfoRemindDays"))?confMap.get("newInfoRemindDays"):"3";
//多页签勾选
String isPageTags = confMap.get("isPageTags")!=null?confMap.get("isPageTags"):"0";
String pageTagsName = confMap.get("pageTags")!=null?confMap.get("pageTagsName"):"";
String pageTagsWhereSQL = confMap.get("pageTags")!=null?confMap.get("pageTagsWhereSQL"):"";

//提醒天数，默认3天
String remindDays = confMap.get("remindDays")!=null&&!"".equals(confMap.get("remindDays"))?confMap.get("remindDays"):"3";
//标题，字段链接，提醒字段 方案id
String titleCaseId = confMap.get("titleCaseId")!=null?confMap.get("titleCaseId"):"";
String linkCaseId = confMap.get("linkCaseId")!=null?confMap.get("linkCaseId"):"";
String remindCaseId = confMap.get("remindCaseId")!=null?confMap.get("remindCaseId"):"";

//选择框信息load初始化
String field = confMap.get("field") != null ? confMap.get("field") : "";
String selectedField = confMap.get("selectedField") != null ? confMap.get("selectedField") : "";
String linkField = confMap.get("linkField") != null ? confMap.get("linkField") : "";
String remindField = confMap.get("remindField") != null ? confMap.get("remindField") : "";

String unselectedOptionHtml = "";
String selectedOptionHtml = "";
//未选择的列表字段
if(!"".equals(field)){
	String[] fieldArr = field.split(",");
	for(int i=0;i<fieldArr.length;i++){
		//每个字段存储格式：12345|whir$t4010_f3060|名称
		String id = fieldArr[i];
		String name = fieldArr[i].substring(fieldArr[i].lastIndexOf("|")+1,fieldArr[i].length());
		unselectedOptionHtml += "<option value=\""+id+"\" >"+name+"</option>"; 
	}
}
//选中的列表字段
if(!"".equals(selectedField)){
	String[] selectedArr = selectedField.split(",");
	for(int i=0;i<selectedArr.length;i++){
		//每个字段存储格式：12345|whir$t4010_f3060|名称
		String id = selectedArr[i];
		String name = selectedArr[i].substring(selectedArr[i].lastIndexOf("|")+1,selectedArr[i].length());
		selectedOptionHtml += "<option value=\""+id+"\" >"+name+"</option>"; 
	}
}

CustomerMenuDB menubd = new CustomerMenuDB();
List cusList = null;
//查询所有“信息列表项”自定义模块
if("1".equals(session.getAttribute("sysManager"))){
	cusList = menubd.getCustomMenuList_portal (CommonUtils.getSessionDomainId(request)+"",
		CommonUtils.getSessionUserId(request)+"",
		"sysManager");
}else{
	cusList = menubd. getCustomMenuList_portal (CommonUtils.getSessionDomainId(request)+"",
		CommonUtils.getSessionUserId(request)+"",
		CommonUtils.getSessionOrgIdString(request)+"");
}
String allMenuList = "";
if (cusList != null) {
	for(int i=0;i<cusList.size();i++){
		Object[] obj = (Object[])cusList.get(i);
		//选项value值：自定义模块Id|表单Id|数据表Id ,名称即为自定义模块名称 供选择
		allMenuList += "<option value=\""+obj[0]+"|"+obj[26]+"|"+obj[10]+"\" >"+obj[1]+"</option>";
	}
}

//初始化默认值
if(limitNum==null||"".equals(limitNum)||"null".equals(limitNum)){
    limitNum = "5";//默认记录数
}
if(titleType==null||"".equals(titleType)||"null".equals(titleType)){
    titleType = "0";
}
%>
<tr>
    <th><em>模块名称：</em></th>
	<td id="clearfix" colspan="3">
		<%
		if(classId!=null&&!"".equals(classId)){
		%>
			<select id="classId" name="classId"  style="width:200px;">     
				<option value="-1" <%=("-1").equals(classId)?"selected":""%>>--请选择模块--</option>
				<%=allMenuList%>  
			</select>
		<%}else{%>
			<select id="classId" name="classId"  style="width:200px;">
				<option value="-1">--请选择模块--</option>
				<%=allMenuList%>
			</select>
		<%}%>
    </td>
</tr>
<%-- 自定义模块保存方案：标题/链接/提醒 三个方案id --%>
<tr style="display:none">
    <th></th>
	<td id="clearfix">
		<div id="caseids">
			<input type="hidden" id="titleCaseId" name="titleCaseId" value="<%=titleCaseId%>">
			<input type="hidden" id="linkCaseId" name="linkCaseId" value="<%=linkCaseId%>">
			<input type="hidden" id="remindCaseId" name="remindCaseId" value="<%=remindCaseId%>">
		</div>
    </td>
</tr>
<tr>
	<th><em>显示样式：</em></th>
	<td>
		<input type="radio" id="displayType0" name="displayType" value="0" onclick="changeField();" <%="0".equals(displayType)?"checked":""%> />
		<label for="displayType0">表格</label>
		<input type="radio" id="displayType1" name="displayType" value="1" onclick="changeField();" <%="1".equals(displayType)?"checked":""%> />
		<label for="displayType1">列表</label>
	</td>
	<th><em>新信息提醒：</em></th>
    <td>
        <div>
          	 <input type="text" id="newInfoRemindDays" name="newInfoRemindDays" class="wh-choose-input-num" value="<%="".equals(newInfoRemindDays)?"3":newInfoRemindDays%>" onkeyup="this.value=this.value.replace(/\D/g,'')"  onafterpaste="this.value=this.value.replace(/\D/g,'')"  maxlength="2"/>
             <span>天</span>
         </div>
    </td>
</tr>
<%-- 多页签 --%>
<tr>
    <th>&nbsp;&nbsp;</th>
	<td  colspan="3">
	<em><input type="checkbox" id="pageTags_checkbox" name="isPageTags" value="1" <%=("1".equals(isPageTags) ? "checked" : "")%> />&nbsp;多页签&nbsp;&nbsp;&nbsp;&nbsp;<a id="add_tags_button2" href="javascript:void(0);" onclick="addNewWhereTag();" class="wh-control-btn-blue" style="font-size: 12px;">新增页签</a></em>
		<div id="add_tags_button" >
		<span style="display: inline-block;margin-top: 4px;"><font color="red">注：在"筛选条件"的输入框中，输入SQL语句的条件（如：whir$123 > 100），无需写where关键字。</font></span><div>
    </td>
</tr>
<tr id="pagestag_content" class="html-selectbox">
	<td id="pagesTag_table_td" colspan="4">
<%
if("1".equals(isPageTags)){
	if(pageTagsName!=null&&!"".equals(pageTagsName)&&!"null".equals(pageTagsName)){
		String[] pageNameArr = pageTagsName.split(",");
		String[] pageWhereArr = pageTagsWhereSQL.split(",,");
		for(int k=0; k < pageNameArr.length; k++){
			//String id_flag = (k+1) +"";
%>
		<table class="pagestag_table_selector" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<th><em>页签名称：</em></th>
				<td colspan="3">
					<div class="wh-choose-info-text wh-choose-info-text-box">
						<input type="text" name="pageTagsName" value="<%=pageNameArr[k]%>" class="wh-choose-input-tabtitle" maxlength="20">
					</div>
				</td>
			</tr>
			<tr>
				<th><em>筛选条件：</em></th>
				<td colspan="3">
					<div class="wh-choose-info-text wh-choose-info-textarea-box">
						<textarea name="pageTagsWhereSQL" value="<%=pageWhereArr[k]%>" class="wh-choose-textarea"><%=pageWhereArr[k]%></textarea>
						<i class="fa fa-times delate" style="color: red" onclick="javascript:removePageContent(this);"></i>
					</div>
				</td>
			</tr>
		</table>
<%
		}
	}
}
%>
	</td>
</tr>
<script>
function addNewWhereTag(){
	var $pageTd = $("#pagesTag_table_td");
	var pagesNum = $('.pagestag_table_selector').length;
	if(pagesNum > 3){
		whir_alert('最多允许添加4个页签！');
		return false;
	}
	//pagesNum ++;
	var html = '<table class="pagestag_table_selector" cellpadding="0" cellspacing="0" width="100%">';
	html += '<tr><th><em>页签名称：</em></th><td colspan="3"><div class="wh-choose-info-text wh-choose-info-text-box">';
	html += '<input type="text" name="pageTagsName" value="" class="wh-choose-input-tabtitle" maxlength="20">';
	html += '</div></td></tr>';
	html += '<tr><th><em>筛选条件：</em></th><td colspan="3"><div class="wh-choose-info-text wh-choose-info-textarea-box">';
	html += '<textarea name="pageTagsWhereSQL" class="wh-choose-textarea"></textarea>';
	html += '<i class="fa fa-times delate" style="color: red" onclick="javascript:removePageContent(this);"></i>';
	html += '</div></td></tr>';
	html += '</table>';
	$pageTd.append(html);

}
//删除添加的页签设置内容
function removePageContent(obj){
	//$("#page_content_"+obj).remove();
	if($(obj).parents(".pagestag_table_selector").eq(0).length > 0){
		$(obj).parents(".pagestag_table_selector").eq(0).remove();
	}
}
</script>
<tr>
	<th><em>列表标题：</em></th>
	<td>
		<input type="radio" id="titleType0" name="titleType" value="0" onclick="changeField();" <%="0".equals(titleType)?"checked":""%> />
		<label for="titleType0">默认</label>
		<input type="radio" id="titleType1" name="titleType" value="1" onclick="changeField();" <%="1".equals(titleType)?"checked":""%> />
		<label for="titleType1">重新定义</label>
	</td>        
</tr>
<%-- 自定义模块字段选择框 左侧未选择 右侧选择 --%>
<tr id="tr_field">
	<td  class="td_lefttitle" ></td>
	<td  height="150px" valign="middle">
		<table width="100%" height="100%"  border="0" cellspacing="0" cellpadding="0" class="table_noline"  style="margin-left:-4px">
			<tr>
				<td width="120px" align="left" valign="middle">
					<select name="field" id="field"  multiple="multiple" size="10" style="width:120px;height:150px">
						<%=unselectedOptionHtml%>
					</select>
				</td>
				<td width="80px" align="center" valign="middle">
					<input type="button" class="btnButton4font" id="button" value="> " onclick='transferOptions("field","selectedField");'/>
					<div style="height:5px">&nbsp;</div>
					<input name="button" type="button" id="button" value=">>" onclick='transferOptionsAll("field","selectedField");' class="btnButton4font" />
					<div style="height:5px">&nbsp;</div>
					<input name="button" type="button" id="button" value="< " onclick='transferOptions("selectedField","field");' class="btnButton4font" />
					<div style="height:5px">&nbsp;</div>
					<input name="button" type="button" id="button" value="<<" onclick='transferOptionsAll("selectedField","field");' class="btnButton4font" />
				</td>
				<td width="120px" align="left"  valign="middle" >
					<select name="selectedField" id="selectedField" multiple="multiple" size="10" style="width:120px;height:150px">
						<%=selectedOptionHtml%>
					</select>
				</td>
				<td >&nbsp;</td>
			</tr>
		</table>
	</td>
	<td>&nbsp;</td>
</tr> 

<tr>
    <th><em>链接字段：</em></th>
	<td id="clearfix">
		<select id="linkField" name="linkField" style="width:200px;">
		</select>
    </td>
</tr>

<tr>
    <th><em>提醒字段：</em></th>
	<td id="clearfix">
		<select id="remindField" name="remindField" style="width:200px;">
		</select>
    </td>
	<th><em>提前提醒：</em></th>
    <td>
        <div>
          	 <input type="text" id="remindDays" name="remindDays" class="wh-choose-input-num" value="<%="".equals(remindDays)?"3":remindDays%>" onkeyup="this.value=this.value.replace(/\D/g,'')"  onafterpaste="this.value=this.value.replace(/\D/g,'')" maxlength="2"/>
             <span>天</span>
         </div>
    </td>
</tr>

<tr>
	<th><em>信息条数：</em></th>
    <td>
        <div class="wh-choose-input-w-box">
            <i class="fa fa-plus wh-pic-num-plus" onClick="setAmount.max=20;setAmount.add('#limitNum')"></i>
                 <input type="text" class="wh-choose-input-num wh-backstage-pic-num" id="limitNum" name="limitNum" value="<%=limitNum%>" maxlength="2" data-minval="1" data-maxval="20" />
			<i class="fa fa-minus wh-pic-num-minus" onClick="setAmount.min=1;setAmount.reduce('#limitNum')"></i>
        </div>
    </td>
	<th><em>列表字数限制：</em></th>
    <td>
      <div class="wh-choose-input">
          <input type="text" class="wh-choose-input-wid" id="limitChar" name="limitChar" value="<%=limitChar%>" maxlength="2"/>
      </div>
    </td>
</tr>
<script type="text/javascript">
$(function(){
	if($("#pageTags_checkbox").prop("checked")){
		$("#add_tags_button").show();
		$("#add_tags_button2").show();
		$("#pagestag_content").show();
	}else{
		$("#add_tags_button").hide();
		$("#add_tags_button2").hide();
		$("#pagestag_content").hide();
	}
		<%if(classId!=null&&!"".equals(classId)){%>
			//页面加载，如果是修改页面，相关预处理	
			$("select[name=classId] option[value='<%=classId%>']").attr("selected","selected");
			//列表标题类型
			if("<%=titleType%>" == "0"){
				$("#tr_field").hide();
			}else{
				$("#tr_field").show();
			}
			//根据classId获取模块menuId,表单formId,数据表tableId
			var classId = "<%=classId%>";
			var idArr = classId.split("|");
			var menuId = idArr[0];
			var formId = idArr[1];
			var tableId = idArr[2];
			
			var json = '';
			//获取表单字段给json
			if(formId.indexOf("new$")!=-1){
				//新自定义表单-自定义模块
				formId = formId.replace("new$","");
				json = ajaxForSync('custormermenu!getListFieldIdByTblId_portal.action?tblId='+tableId);
			}else{
				//(老)自定义表单-自定义模块
				json = ajaxForSync('custormermenu!getListFieldIdByTblId_portal.action?tblId='+tableId);
			}
			//链接字段下拉列表加载
			if(json!='')
				json = eval("("+json+")");
			if(json.length>0){
				var html="";
				for(var i = 0; i < json.length; i++) {
					var obj = json[i];
					//link字段是否被选中的标识
					var lflag = "";
					if("<%=linkField%>" == (obj.id+"|"+obj.text)){
						lflag = "selected";
					}
					//link字段保存value值格式：12345|whir$t4010_f3054|名称
					html+="<option value='"+obj.id+"|"+obj.text+"' "+lflag+">"+obj.text+"</option>";
				}
				var html_link = "<option value='-1|-1|--请选择--'>--请选择--</option>"+html;
				$("#linkField").html(html_link);
			}
			//提醒字段下拉列表加载，使用的查询方法过滤了非日期类型的字段
			var json_remind = ajaxForSync('Field!getPageField.action?tableId='+tableId);
			if(json_remind!='')
				json_remind = eval("("+json_remind+")");
			var html2 = "";
			for(var j = 0; j < json_remind.length; j++) {
				var obj = json_remind[j];
				//提醒字段是否被选中的标识
				var sflag = "";
				if("<%=remindField%>" == (obj.id+"|"+obj.name)){
					sflag = "selected";
				}
				html2+="<option value='"+obj.id+"|"+obj.name+"' " + sflag +">"+obj.name+"</option>";
			}
				var html_remind = "<option value='-1|-1|--请选择--'>--请选择--</option>"+html2;
				$("#remindField").html(html_remind);

		<%}else{%>
			//页面加载，如果是新增页面，相关预处理
			$("#tr_field").hide();
		<%}%>
});

$("#classId").bind("change", function(){
	//改变选择的自定义模块，初始化列表字段等信息
	//$('input[name=titleType][value=0]').attr("checked","checked");
	//changeField();
	var classId = $("select[name=classId]").val();
	if(classId != null && !("" == classId)){
		var html_link = "";
		var idArr = classId.split("|");
		var menuId = idArr[0];
		var formId = idArr[1];
		var tableId = idArr[2];
		// if classId = "-1" 的情况：提示必须选择一个自定义模块
		if(formId.indexOf("new$")!=-1){
			//新自定义表单-自定义模块
			formId = formId.replace("new$","");
			var json = ajaxForSync('custormermenu!getListFieldIdByTblId_portal.action?tblId='+tableId);
			if(json!='')
				json = eval("("+json+")");
			//清空表单字段选择框内容
			$("#selectedField").empty();
			if(json.length>0){
				var html="";
				for(var i = 0; i < json.length; i++) {
					var obj = json[i];
					html+="<option value='"+obj.id+"|"+obj.text+"'>"+obj.text+"</option>";
				}
				html_link = html;
				$("#field").html(html);
			}
		}else{
			//(老)自定义表单-自定义模块
			var json = ajaxForSync('custormermenu!getListFieldIdByTblId_portal.action?tblId='+tableId);
			if(json!='')
				json = eval("("+json+")");
			//清空表单字段选择框内容
			$("#selectedField").empty();
			if(json.length>0){
				var html="";
				for(var i = 0; i < json.length; i++) {
					var obj = json[i];
					html+="<option value='"+obj.id+"|"+obj.text+"'>"+obj.text+"</option>";
				}
				html_link = html;
				$("#field").html(html);
			}
		}

		//链接字段 填充下拉选项
		html_link = "<option value='-1|-1|--请选择--'>--请选择--</option>"+html_link;
		$("#linkField").html(html_link);
		//提醒字段 填充下拉选项
		var json_remind = ajaxForSync('Field!getPageField.action?tableId='+tableId);
		if(json_remind!='')
			json_remind = eval("("+json_remind+")");
		var html2 = "";
		for(var j = 0; j < json_remind.length; j++) {
			var obj = json_remind[j];
			html2+="<option value='"+obj.id+"|"+obj.name+"'>"+obj.name+"</option>";
		}
		var html_remind = "<option value='-1|-1|--请选择--'>--请选择--</option>"+html2;
		$("#remindField").html(html_remind);
	}
});

function changeField(){
	var titleType = $("input[name=titleType]:checked").val();
	if(titleType == "1"){
		$("#tr_field").show();
	}else {
		$("#tr_field").hide();
		//切换为“默认”，清空选择字段
		transferOptionsAll("selectedField","field");
	}
}

$("#pageTags_checkbox").bind("click", function(){
	if($(this).prop("checked")){
		$("#add_tags_button").show();
		$("#add_tags_button2").show();
		$("#pagestag_content").show();
	}else{
		$("#add_tags_button").hide();
		$("#add_tags_button2").hide();
		$("#pagestag_content").hide();
	}
});
</script>
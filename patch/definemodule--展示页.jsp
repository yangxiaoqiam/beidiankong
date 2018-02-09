<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/public/include/init.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="com.whir.ezoffice.portal.bd.*"%>
<%@ page import="com.whir.ezoffice.portal.po.*"%>
<%@ page import="com.whir.ezoffice.portal.common.util.*"%>
<%@ page import="com.whir.ezoffice.portal.cache.*"%>
<%@ page import="com.whir.ezoffice.portal.vo.*"%>
<%@ page import="com.whir.common.util.CommonUtils"%>
<%@ page import="com.whir.common.util.DataSourceBase"%>
<%@ page import="com.whir.ezoffice.customize.customermenu.bd.*"%>
<%
response.setContentType("text/html; charset=UTF-8");
String portletSettingId = request.getParameter("portletSettingId");
boolean _outter_ = "1".equals(request.getParameter("outter"));
String _outter_arg = "";
if(_outter_){
    _outter_arg = "&outter=1";
}

ModuleVO mvo = (ModuleVO)request.getAttribute("mvo");
if(mvo!=null){
	PortletBD pbd = new PortletBD();
	ConfMap confMap = pbd.getConfMap(portletSettingId);
	String classId = confMap.get("classId")==null ? "" : confMap.get("classId");
	//自定义模块Id
	String menuId = "";
	//表单Id
	String formId = "";
	//数据表Id
	String tableId = "";
	if(!"".equals(classId)){
		String[] idArr = classId.split("\\|");
		menuId = idArr[0];
		formId = idArr[1];
		tableId = idArr[2];
	}
	//获取自定义模块表单的日期类型字段，用于特殊样式处理（日期字段,逗号隔开，后续判断是否是日期类型做不同样式控制）
	com.whir.ezoffice.customdb.customdb.bd.CustomDatabaseBD localCustomDatabaseBD = new com.whir.ezoffice.customdb.customdb.bd.CustomDatabaseBD();
    String[][] arrayOfString = localCustomDatabaseBD.getPageField(tableId);
    String table_dateStr = "";
    if (arrayOfString != null){
		for (int aa = 0; aa < arrayOfString.length; aa++){
			table_dateStr = table_dateStr +  arrayOfString[aa][2] + ",";
		}
	}
	//列表标题 类型
	String titleType = confMap.get("titleType");
	//信息条数
	String limitNum = confMap.get("limitNum");
	//列表第一列字数限制
	String limitChar = ( confMap.get("limitChar")==null || "".equals(confMap.get("limitChar")) ) ? "12" : confMap.get("limitChar");
	//显示样式，新信息提醒时限
	String displayType = confMap.get("displayType")!=null && !"".equals(confMap.get("displayType")) ? confMap.get("displayType") : "0"; //默认表格样式
	String newInfoRemindDays = confMap.get("newInfoRemindDays")!=null&&!"".equals(confMap.get("newInfoRemindDays"))?confMap.get("newInfoRemindDays"):"3";
	//提前提醒天数
	String remindDays = confMap.get("remindDays")!=null&&!"".equals(confMap.get("remindDays"))?confMap.get("remindDays"):"3";
	//标题 链接 提醒方案Id
	String titleCaseId = confMap.get("titleCaseId")!=null?confMap.get("titleCaseId"):"";
	String linkCaseId = confMap.get("linkCaseId")!=null?confMap.get("linkCaseId"):"";
	String remindCaseId = confMap.get("remindCaseId")!=null?confMap.get("remindCaseId"):"";
	//选择列表字段相关信息
	String field = confMap.get("field") != null ? confMap.get("field") : "";
	String selectedField = confMap.get("selectedField") != null ? confMap.get("selectedField") : "";
	//链接字段
	String linkField = confMap.get("linkField") != null ? confMap.get("linkField") : "";
	//提前提醒字段
	String remindField = confMap.get("remindField") != null ? confMap.get("remindField") : "";
	//多页签勾选
	String isPageTags = confMap.get("isPageTags")!=null?confMap.get("isPageTags"):"0";
	String pageTagsName = confMap.get("pageTags")!=null?confMap.get("pageTagsName"):"";
	//多页签对应的查询条件
	String pageTagsWhereSQL = confMap.get("pageTags")!=null?confMap.get("pageTagsWhereSQL"):"";	
	if("1".equals(isPageTags) && !"".equals(pageTagsName)){ //多页签
		String[] pagesNameArr = pageTagsName.split(",");
%>
<script>
var jsonData = [
	{
		ulCss:"wh-portal-title-slide04-<%=portletSettingId%>",
		data:[
		<%
    	for(int i0=0; i0<pagesNameArr.length; i0++){
			String pageName = (String)pagesNameArr[i0];
            String linkUrl = "";
        %>
			<%if(i0 > 0){%>,<%}%>{title:"<%=pageName%>", url:"", onclick:"<%=linkUrl%>", defaultSelected:"<%=i0==0?"on":""%>",liCss:"wh-portal-overflow", morelink:"<%=linkUrl%>"}
		<%}%>	
		]
	}	
];
Portlet.setPortletDataTitle('<%=portletSettingId%>',jsonData);
//Portlet.setMoreLink('<%=portletSettingId%>',{});
</script>
<%	
	} //针对 多页签 场景，顶部多页签展示的js处理 结束
%>
<script>
//初始化列表数据
function initResultList(headerContainer,resultjson,index,displayType,table_dateStr){
	var html = '';
	//列表表头的处理
	var headstr = headerContainer;
	if(headstr == null || headstr == ""){
		return false;
	}
	if(displayType == '1'){
		//列表展示方式，不展示头部字段名称
	}else{
		html += headstr;
	}
	
	//列表内容：查询结果的处理
	var resultstr = resultjson;
	if(resultstr == null || resultstr == ""){
		return false;
	}
	//alert(resultstr);
	var data = eval('('+resultstr+')');
	for(var i in data){
		var trobj = data[i];
		var tr = '<tr>';
		var trobj_date_flag = '0';
		var td_index = 0;
		for(var key in trobj){
			var td = '';
			//返回json串第一个key是id，第二个是创建日期，不用展示
			if(key == 'date'){
				trobj_date_flag = trobj[key];
			}
			if(key != 'id' && key != 'date'){
				if(displayType == '1'){
					//列表样式，针对日期类型的统一居右对齐；新信息提醒时限内，增加new图标的展示；第一个字段前面增加圆点图案
					td += '<td'+ (table_dateStr.indexOf(key+',') != -1 ? ' class="portlet-define-settime" ' : '') + '>' + (td_index == 0 ? '<i class="fa fa-new-arrow"></i>' : '') + '<div>';
					td += trobj[key] + '</div>'+ (td_index==0 && trobj_date_flag=='1' ? '<i class="fa fa-new" style="color:red;"></i>' : '') +'</td>';
					td_index ++;
				}else{
					td += '<td>' + trobj[key] + '</td>';
				}
			}
			tr += td;
		}
		tr += '</tr>';
		html += tr;
	}
	//alert(html);
	$("#dfmodule<%=portletSettingId%>-"+index).html(html);
}
</script>
<style>
	.portlet-define-setbox{border:0;margin:0;}
	.portlet-define-setbox table{table-layout: fixed;}
	.portlet-define-setbox tr td{text-align: left;border-left:0 none;border-top:0 none;border-bottom:1px dashed #e0e0e0;padding:0;height:auto}
	.portlet-define-setbox tr td  div{
	       display: inline-block;

    color: #202020;
    cursor: default;
    text-overflow: ellipsis;
    overflow: hidden;
    word-break: keep-all;
    word-wrap: normal;
    white-space: nowrap;
    position: relative;
    cursor: pointer;
    max-width: 79%;
    height: 40px;
    line-height: 40px;
    float: left;
	}
	.portlet-define-setbox tr td i{
	font-size: 12px;
    position: relative;
    top: 0;
    margin-right: 3px;
    height: 40px;
    line-height: 42px;
    color: #b7b7b7;
    float: left;}
	.portlet-define-setbox tr td.portlet-define-settime{text-align: right;width:100px;}
	.portlet-define-setbox tr td.portlet-define-settime div{float:right;max-width:none;margin-right:13px;}
	.size-small .portlet-define-setbox td a,.size-small .portlet-define-setbox td a div{font-size:12px;}
	.size-big .portlet-define-setbox td a,.size-big .portlet-define-setbox td a div{font-size:14px;}
	.size-big16 .portlet-define-setbox td a,.size-big16 .portlet-define-setbox td a div{font-size:16px;}
	.portlet-define-setbox tr td.portlet-define-settime div{color: #bcbcbc; cursor: auto;}
	.portlet-define-setbox td a{color: #202020;}
</style>

<div class="wh-portal-slide04-<%=portletSettingId%>">
	<ul class="clearfix">
<%
	String domainId = CommonUtils.getSessionDomainId(request).toString();
	CustomerMenuDB menubd = new CustomerMenuDB();
	Map headMap = new HashMap();
	//表头字段
	String headerContainer = "";
	//其他需要特殊处理字段
	String hasNewForm = "";
	//列表查询返回结果json
	String resultjson = "";
	if(!"".equals(menuId)){
		headMap = menubd.goRightMenu_portal(menuId, domainId, titleCaseId, request);
		headerContainer = headMap.get("headerContainer").toString();
		//查询列表数据所需参数
		String rightType = headMap.get("rightType").toString();
		String defineOrgs = headMap.get("defineOrgs").toString();
		String isRefFlow = headMap.get("isRefFlow").toString();
		String isNewRefFlow = headMap.get("isNewRefFlow").toString();
		hasNewForm = headMap.get("hasNewForm").toString();
		//需要特殊处理的参数
		String link_tbName = "";
		String remind_tbName = "";
		if(!"".equals(linkField) && (linkField.indexOf("|") > -1) && (linkField.lastIndexOf("|") >= linkField.indexOf("|")+1) ){
			link_tbName = linkField.substring(linkField.indexOf("|")+1, linkField.lastIndexOf("|"));
		}
		if(!"".equals(remindField) && (remindField.indexOf("|") > -1) && (remindField.lastIndexOf("|") >= remindField.indexOf("|")+1) ){
			remind_tbName = remindField.substring(remindField.indexOf("|")+1, remindField.lastIndexOf("|"));
		}
		if("-1".equals(link_tbName)){
			link_tbName = "";
		}
		if("-1".equals(remind_tbName)){
			remind_tbName = "";
		}
		//此处区分是否选择了多页签的情况，并且默认最多可以设置4个页签，如果查询条件多于4个，只取前四个（防止因为,,分隔进行split的时候，最后多出空串的场景）
		int maxTags = 4;
		if("1".equals(isPageTags)){
		
		}else{
			maxTags = 1;
		}
		String[] pagesWhereArr = pageTagsWhereSQL.split(",,");
		int i=0;
		for(; i<(pagesWhereArr.length > maxTags ? maxTags : pagesWhereArr.length); i++){
			if(i == 0){
		%>
		<li>
	<%	}else{	%>
		<li class="wh-portal-hidden">
	<%	}
		//区分不同查询sql条件 进行结果渲染
		//查询列表
		if(maxTags == 1 || (pagesWhereArr[i]==null || "".equals(pagesWhereArr[i]))){
			resultjson = menubd.getCustDataList_portal(menuId, domainId, isRefFlow, isNewRefFlow, rightType, defineOrgs, Integer.valueOf(remindDays), Integer.valueOf(limitNum), remind_tbName, link_tbName, titleCaseId, request, "",newInfoRemindDays,limitChar);
		}else{
			resultjson = menubd.getCustDataList_portal(menuId, domainId, isRefFlow, isNewRefFlow, rightType, defineOrgs, Integer.valueOf(remindDays), Integer.valueOf(limitNum), remind_tbName, link_tbName, titleCaseId, request, pagesWhereArr[i],newInfoRemindDays,limitChar);
		}
		resultjson = resultjson.replaceAll("\"","\\\\\"");
		%>
		<%if(headerContainer!=null && !"".equals(headerContainer)){%>
		<div class="wh-human-remind wh-portal-slide04-<%=portletSettingId%> <%=("1".equals(displayType) ? "portlet-define-setbox" : "")%>">
			<table id="dfmodule<%=portletSettingId%>-<%=i%>" cellpadding="0" cellspacing="0" class="wh-human-remind-tab">
			</table>
		</div>
		<%}%>
		</li>
			<script>initResultList('<%=headerContainer%>',"<%=resultjson%>",'<%=i%>','<%=displayType%>','<%=table_dateStr%>');</script>
		<%}%>
<%
	}	// !"".equals(menuId)  --end 	
%>
</ul></div>
<script language="javascript">
slideTab('slide04-<%=portletSettingId%>');
</script>
<%}%>

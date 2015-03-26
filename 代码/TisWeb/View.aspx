<%@ Page Language="C#"  %>
 
<%
    var user = TisWeb.Models.UserInfo.CurrentUser();
    if (user.state !=1)
    {
        Response.End();
    }
     %>
<%=user.data.ip %>
<%=user.data.linetype %>
<%=user.data.province %>
<%=user.data.district %>
<%=user.data.country %>
<%=user.data.city %>
<%=user.data.area %>
<%=user.OS %>
<%=user.Agent %>
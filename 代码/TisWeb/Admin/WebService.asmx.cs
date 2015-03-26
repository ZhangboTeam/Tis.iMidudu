using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using TisWeb.Models;
namespace TisWeb.Admin
{
    /// <summary>
    /// Summary description for WebService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
     [System.Web.Script.Services.ScriptService]
    public class WebService : System.Web.Services.WebService
    {

        [WebMethod(EnableSession = true)]
        public bool Login(string userName, string password)
        {
            var ok =  SqlHelper.Exists("select count(1) from SystemUser where LoginName=@LoginName and Password= @Password", new System.Data.SqlClient.SqlParameter("@LoginName", userName), new System.Data.SqlClient.SqlParameter("@Password", password));
            if (ok)
            {
                System.Web.HttpContext.Current.Session["UserName"] = userName;
            }
            return ok;
        }

    }
}

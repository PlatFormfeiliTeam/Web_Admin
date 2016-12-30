using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
/// <summary>
/// Config 的摘要说明
/// </summary>
public class ConfigHandler : Handler
{
    public ConfigHandler(HttpContext context) : base(context) { }

    public override void Process()
    {
        string imageUrlPrefix = ConfigurationManager.AppSettings["imageUrlPrefix"];
        var obj = Config.Items;
        if (imageUrlPrefix != null)
        {
            obj.Remove("imageUrlPrefix");
            obj.Add("imageUrlPrefix", imageUrlPrefix);

        }
        WriteJson(obj);
    }
}
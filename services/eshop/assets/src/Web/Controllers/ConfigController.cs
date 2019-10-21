using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Linq;

namespace Microsoft.eShopWeb.Web.Controllers
{
    public class ConfigController : Controller
    {
        private readonly IConfiguration _config;

        public ConfigController(IConfiguration config)
        {
            _config = config;
        }

        // GET: /<controller>/
        public IActionResult Index()
        {           
            if (_config.GetValue<bool>("ConfigController:Enabled")) 
            {
                return Json(_config.AsEnumerable());
            }
            else
            {
                return NotFound();
            }
        }
    }
}

var moment=require("moment");require("moment-timezone"),module.exports=function(e,m,o){var t=moment();if(void 0!==e.timezone){var r=t.tz(e.timezone);void 0!==r&&(t=r)}o(null,{hour:t.format("HH"),minutes:t.format("mm"),dateStr:t.format("YYYY-MM-DD")})};
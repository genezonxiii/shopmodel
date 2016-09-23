/* 行事曆
--------------------------------------------------------------------- */
var opt = {
   //dayNames:["星期日","星期一","星期二","星期三","星期四","星期五","星期六"],
   dayNamesMin:["日","一","二","三","四","五","六"],
   monthNames:["1","2","3","4","5","6","7","8","9","10","11","12"],
   monthNamesShort:["1","2","3","4","5","6","7","8","9","10","11","12"],
   //monthNamesShort:["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"],
   prevText:"上月",
   nextText:"次月",
   weekHeader:"週",
   showMonthAfterYear:true,
   dateFormat:"yy/mm/dd",
   changeYear: true,
   changeMonth: true
   };

$(function(){
  $( ".input-date" ).datepicker(opt);

  // 表格內的操作按鈕動作
  // $('.table-row-func').hover(function(){
  //   var tfl = $(this).find('.table-function-list');
  //   var tfl_w = $(this).find('a').length * 36; // 算出寬度
  //   tfl.toggleClass('hover').css('width',tfl_w);
  // });

});
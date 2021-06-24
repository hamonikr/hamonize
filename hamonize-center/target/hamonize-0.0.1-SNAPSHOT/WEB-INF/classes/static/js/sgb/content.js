
$(document).ready(function () {

    //입렵폼 
    $('input').focus(function(event) {
      $(this).closest('.join-field').addClass('float').addClass('focus');
    })

    $('input').blur(function() {
      $(this).closest('.join-field').removeClass('focus');
      if (!$(this).val()) {
        $(this).closest('.join-field').removeClass('float');
      }
    });    

    //파일찾기 
    var uploadFile = $('.fileBox .uploadBtn');
    uploadFile.on('change', function(){
        if(window.FileReader){
            var filename = $(this)[0].files[0].name;
        } else {
            var filename = $(this).val().split('/').pop().split('\\').pop();
        }
        $(this).siblings('.fileName').val(filename);
    });
    
    
    //달력
    $("#date1").datepicker({
        showOn: "button",
        buttonImage: "/images/datepicker-icon.png",
        buttonImageOnly: false,
        buttonText: "Select date"
    });

    $("#date2").datepicker({
        showOn: "button",
        buttonImage: "/images/datepicker-icon.png",
        buttonImageOnly: false,
        buttonText: "Select date"
    });

});




 //드롭메뉴 
function myFunction() {
  document.getElementById("drop").classList.toggle("show");
}

// Close the dropdown if the user clicks outside of it
window.onclick = function(event) {
  if (!event.target.matches('.dropbtn')) {
    var dropdowns = document.getElementsByClassName("dropdown_content");
    var i;
    for (i = 0; i < dropdowns.length; i++) {
      var openDropdown = dropdowns[i];
      if (openDropdown.classList.contains('show')) {
        openDropdown.classList.remove('show');
      }
    }
  }
}











    



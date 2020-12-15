$( document ).ready(function() {
  $("#form-search-room-admin").submit(function(e) {
    var start_price = $("#start_price").val();
    var end_price = $("#end_price").val();
    if (isNaN(start_price) || isNaN(end_price)) {
      alert(I18n.t("admins.err_price"))
      return false;
    } else {
      if(parseFloat(start_price) > parseFloat(end_price)) {
        alert(I18n.t("admins.err_price2"))
        return false;
      }
    }
  });

  $(".btn-delete-img").on("click", function() {
    var btn = $(this);
    btn.parent().remove();
    $(".box-img-deleted").append('<input name="room[room_pictures_attributes][][id]" value="'+btn.data("id")+'" type="hidden">');
    $(".box-img-deleted").append('<input name="room[room_pictures_attributes][][_destroy]" value="1" type="hidden">');
  });

  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function(e) {
        $("#blah").attr("src", e.target.result);
      }

      reader.readAsDataURL(input.files[0]);
    }
  }

  $("#imgInp").change(function() {
    readURL(this);
  });

  function previewMultipleImg(input) {
    Array.from(input.files).forEach(function(item, index) {
      var reader = new FileReader();
      reader.onload = function(e) {
        var html = '<div class="box-img">';
        html += '<img class="img-room-detail" src="'+ e.target.result +'">';
        html += '</div>';
        $(".room-mul-pic").append(html);
      }
      reader.readAsDataURL(input.files[index]);
    });
  }

  $("#imgMulInp").change(function() {
    previewMultipleImg(this);
  });
});

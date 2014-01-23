


var chat={}


chat.fetchPesan=function(){
	$.ajax({
		url:'/chat/show?scroll=down',
		type:'GET',
		data:{method: 'fetch'},
		success: function(data){
			$('.chat .tampil').html(data);
		}
	});
}
chat.fetchPesan1=function(){
	$.ajax({
		url:'/chat/show',
		type:'GET',
		data:{method: 'fetch'},
		success: function(data){
			$('.chat .tampil').html(data);
		}
	});
}
chat.fetchPesan1();

$('form').submit(function() {  
    var valuesToSubmit = $(this).serialize();
    $.ajax({
        url: $(this).attr('action'), 
        data: valuesToSubmit,
        dataType: "JSON" 
    }).success(function(json){
        console.log(json)
    });
    return false; // prevents normal behaviour
});



$('#formpesan').submit(function() {
		$.ajax({
			type: 'POST',
			url: $(this).attr('action'),
			data: $(this).serialize(),
			success: function(data) {
				//$('#result').html(data);
				console.log(data)
			}
		})
		return false;
	});

$( "form" ).on( "submit", function( event ) {
  event.preventDefault();
  console.log( $( this ).serialize() );
});




chat.pesan=$('.chat .pesan');
chat.pesan.bind('keydown', function(e){
	console.log(1);
	
});

$(document).ready(function(e){
	$('#pesan').keydown(function(e){
    	if(e.keyCode==13){
    		chat.pushPesan();
    		$('#pesan').val('');
    	}
	});
$('#formpesan').submit(function() {
		$.ajax({
			type: 'POST',
			url: $(this).attr('action'),
			data: $(this).serialize(),
			success: function(data) {
				//$('#result').html(data);
				console.log(data);
				chat.fetchPesan();
				$('#pesan').val('');

			}
		})
		return false;
	});


});

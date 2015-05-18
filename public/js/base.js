$(document).ready(function () {
	$('select').material_select();

	$('.membership-select__header').click(function () {
		$('.membership-select__body').slideUp(300);
		$(this).next('.membership-select__body').slideDown(300);
	});
});
document.addEventListener('DOMContentLoaded', function() {
  const selectAllCheckbox = document.getElementById('select_all_checkbox');
  const userCheckboxes = document.querySelectorAll('input[name="user_ids[]"]');
  
  selectAllCheckbox.addEventListener('change', function() {
    userCheckboxes.forEach(function(checkbox) {
      checkbox.checked = selectAllCheckbox.checked;
    });
  });
});
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#experiment_problem_number').parent().hide()

  states = $('#experiment_problem_number').html()

  change_select = () ->
    domain_id = $('#experiment_domain_id :selected').attr('value')
    req = $.getJSON("/domains/#{domain_id}.json", (data, resp) ->
      domain_limit = data.number_of_problems
      $('#experiment_problem_number').parent().show()
      options = $(states).filter ->
        $(this).attr('value') <= domain_limit
      $('#experiment_problem_number').html(options)
      console.log(domain_limit)
    )

  $('#experiment_domain_id').change ->
    change_select()
    
  change_select()

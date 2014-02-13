# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#experiment_problem_id').parent().hide()

  states = $('#experiment_problem_id').html()

  change_select = () ->
    domain_id = $('#experiment_domain_id :selected').attr('value')
    req = $.getJSON("/domains/#{domain_id}/problem_list.json", (data, resp) ->

      if data.length == 0
        $('#experiment_submit').hide()
        $('#experiment_problem_id').parent().hide()
        return

      $('#experiment_submit').show()
      $('#experiment_problem_id').parent().show()

      options = $(states).filter ->
        for problem in data
          if +$(this).attr('value') == problem['id']
            return true
        return false

      $('#experiment_problem_id').html(options)
    )

  $('#experiment_domain_id').change ->
    change_select()
    
  change_select()

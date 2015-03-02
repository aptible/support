document.addEventListener 'DOMContentLoaded', ->
  form = document.getElementById('support-form')
  return unless form
  name = document.getElementById('support-form-name')
  email = document.getElementById('support-form-email')
  message = document.getElementById('support-form-message')
  alert = document.getElementById('support-form-alert')
  alertText = document.getElementById('support-form-alert-text')

  alert.style.display = 'none'

  onFormSubmit = (e) ->
    alert.style.display='none'

    nameVal = name.value
    emailVal = email.value
    messageVal = message.value

    if nameVal && emailVal && messageVal
      alert.className = 'alert alert-success'
      alert.style.display = 'block'
      alertText.innerHTML = 'Thanks! Someone from Support will contact you shortly.'

      setTimeout (->
        name.value = ''
        email.value = ''
        message.value = ''
      ), 50
      true

    else
      e.preventDefault()
      alert.className = 'alert alert-danger'
      alert.style.display = 'block'
      alertText.innerHTML = 'Name, Email, and Message are all required fields'

  form.addEventListener('submit', onFormSubmit)

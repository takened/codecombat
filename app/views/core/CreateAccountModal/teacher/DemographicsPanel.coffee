DemographicsPanel = Vue.extend
  name: 'demographics-panel'
  template: require('templates/core/create-account-modal/demographics-panel')()
  data: ->
    formData = _.pick(@$store.state.modal.trialRequestProperties, [
      'numStudents'
      'numStudentsTotal'
      'notes'
      'referrer'
      'educationLevel'
      'otherEducationLevel'
      'otherEducationLevelExplanation'
    ])
    return _.assign(formData, {
      showRequired: false
    })
  computed:
    educationLevelComplete: ->
      if @otherEducationLevel and not @otherEducationLevelExplanation
        return false
      return @educationLevel.length or @otherEducationLevel
  methods:
    clickContinue: ->
      window.tracker?.trackEvent 'CreateAccountModal Teacher DemographicsPanel Signup Clicked', category: 'Teachers', ['Mixpanel']
      requiredAttrs = _.pick(@, 'numStudents', 'numStudentsTotal', 'educationLevelComplete')
      unless _.all(requiredAttrs)
        @showRequired = true
        return
      @commitValues()
      window.tracker?.trackEvent 'CreateAccountModal Teacher DemographicsPanel Signup Success', category: 'Teachers', ['Mixpanel']
      @$emit('continue')

    commitValues: ->
      attrs = _.pick(@, 'numStudents', 'numStudentsTotal', 'notes', 'referrer', 'educationLevel', 'otherEducationLevel', 'otherEducationLevelExplanation')
      @$store.commit('modal/updateTrialRequestProperties', attrs)

    clickBack: ->
      @commitValues()
      window.tracker?.trackEvent 'CreateAccountModal Teacher DemographicsPanel Back Clicked', category: 'Teachers', ['Mixpanel']
      @$emit('back')

  mounted: ->
    @$refs.focus.focus()

module.exports = DemographicsPanel

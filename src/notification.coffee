Delegator = require './class'
Util = require './util'


# Public: A simple notification system that can be used to display information,
# warnings and errors to the user. Display of notifications are controlled
# cmpletely by CSS by adding/removing the @options.classes.show class. This
# allows styling/animation using CSS rather than hardcoding styles.
class Notification extends Delegator

  # Sets events to be bound to the @element.
  events:
    "click": "hide"

  # Default options.
  options:
    html: "<div class='annotator-notice'></div>"
    classes:
      show:    "annotator-notice-show"
      info:    "annotator-notice-info"
      success: "annotator-notice-success"
      error:   "annotator-notice-error"

  # Public: Creates an instance of  Notification and appends it to the
  # document body.
  #
  # options - The following options can be provided.
  #           classes - A Object literal of classes used to determine state.
  #           html    - An HTML string used to create the notification.
  #
  # Examples
  #
  #   # Displays a notification with the text "Hello World"
  #   notification = new Annotator.Notification
  #   notification.show("Hello World")
  #
  # Returns
  constructor: (options) ->
    super $(@options.html)[0], options

  # Public: Displays the annotation with message and optional status. The
  # message will hide itself after 5 seconds or if the user clicks on it.
  #
  # message - A message String to display (HTML will be escaped).
  # status  - A status constant. This will apply a class to the element for
  #           styling. (default: Annotator.Notification.INFO)
  #
  # Examples
  #
  #   # Displays a notification with the text "Hello World"
  #   notification.show("Hello World")
  #
  #   # Displays a notification with the text "An error has occurred"
  #   notification.show("An error has occurred", Annotator.Notification.ERROR)
  #
  # Returns itself.
  show: (message, status=Notification.INFO) =>
    @currentStatus = status
    this._appendElement()

    $(@element)
      .addClass(@options.classes.show)
      .addClass(@options.classes[@currentStatus])
      .html(Util.escape(message || ""))

    setTimeout this.hide, 5000
    this

  # Public: Hides the notification.
  #
  # Examples
  #
  #   # Hides the notification.
  #   notification.hide()
  #
  # Returns itself.
  hide: =>
    @currentStatus ?= Annotator.Notification.INFO
    $(@element)
      .removeClass(@options.classes.show)
      .removeClass(@options.classes[@currentStatus])
    this

  # Private: Ensures the notification element has been added to the document
  # when it is needed.
  _appendElement: ->
    if not @element.parentNode?
      $(@element).appendTo(document.body)

# Constants for controlling the display of the notification. Each constant
# adds a different class to the Notification#element.
Notification.INFO    = 'info'
Notification.SUCCESS = 'success'
Notification.ERROR   = 'error'

# Export Notification object
module.exports = Notification

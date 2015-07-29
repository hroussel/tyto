module.exports = Backbone.Marionette.ItemView.extend
  tagName        : 'div'

  className      : ->
    this.domAttributes.VIEW_CLASS + this.model.attributes.color

  attributes     : ->
    attr = {}
    attr[this.domAttributes.VIEW_ATTR] = this.model.get 'id'
    attr

  template       : Tyto.TemplateStore.task

  ui:
    deleteTask   : '.tyto-task__delete-task'
    editTask     : '.tyto-task__edit-task'
    trackTask    : '.tyto-task__track-task'
    description  : '.tyto-task__description'
    title        : '.tyto-task__title'
    menu         : '.tyto-task__menu'
    hours        : '.tyto-task__time__hours'
    minutes      : '.tyto-task__time__minutes'
    time         : '.tyto-task__time'

  events:
    'click @ui.deleteTask'     : 'deleteTask'
    'click @ui.editTask'       : 'editTask'
    'click @ui.trackTask'      : 'trackTask'
    'blur @ui.title'           : 'saveTaskTitle'
    'blur @ui.description'     : 'saveTaskDescription'

  domAttributes:
    VIEW_CLASS          : 'tyto-task mdl-card mdl-shadow--2dp bg--'
    VIEW_ATTR           : 'data-task-id'
    IS_BEING_ADDED_CLASS: 'is--adding-task'
    COLUMN_CLASS        : '.tyto-column'
    TASK_CONTAINER_CLASS: '.tyto-column__tasks'
    HIDDEN_UTIL_CLASS   : 'is--hidden'

  getMDLMap: ->
    view = this
    [
      el       : view.ui.menu[0]
      component: 'MaterialMenu'
    ]

  initialize: ->
    view = this
    attr = view.domAttributes
    view.$el.on Tyto.ANIMATION_EVENT, ->
      $(this).parents(attr.COLUMN_CLASS).removeClass attr.IS_BEING_ADDED_CLASS

  deleteTask: ->
    this.model.destroy()

  onShow: ->
    view = this
    attr = view.domAttributes
    # Handles scrolling to the bottom of a column if necessary so user sees
    # rendering animation on creation.
    container = view.$el.parents(attr.TASK_CONTAINER_CLASS)[0]
    column    = view.$el.parents(attr.COLUMN_CLASS)
    if container.scrollHeight > container.offsetHeight and column.hasClass(attr.IS_BEING_ADDED_CLASS)
      container.scrollTop = container.scrollHeight
    # Upgrade MDL components.
    Tyto.Utils.upgradeMDL view.getMDLMap()

  onRender: ->
    view = this
    Tyto.Utils.renderTime view

  trackTask: (e) ->
    Tyto.Utils.showTimeModal this.model, this

  editTask: (e) ->
    view    = this
    boardId = view.model.get 'boardId'
    taskId  = view.model.id
    editUrl = '#board/' + boardId + '/task/' + taskId
    Tyto.Utils.bloom view.ui.editTask[0], view.model.get('color'), editUrl

  saveTaskDescription: ->
    this.model.save
      description: this.ui.description.html()

  saveTaskTitle: ->
    this.model.save
      title: this.ui.title.text().trim()

GoogleSpreadsheet = require 'google-spreadsheet'
_ = require 'underscore'

class Sheets

  constructor: (sheetId)->
    @gs = new GoogleSpreadsheet sheetId
    @workSheets = null

  authorise: (cb)->
    credentials = config.get 'credentials.google_sheet'
    credentials = require credentials['file']
    @gs.useServiceAccountAuth credentials, (e, auth)=>
      return cb.apply @, [e]

  getInfo: (cb)->
    @authorise (e)=>
      return cb.apply @, [e] if e?

      @gs.getInfo (e, info)=>
        return cb.apply @, [e] if e?

        @workSheets = info['worksheets']
        return cb.apply @, [null, @workSheets]

  getSampleSheet: (cb)->
    @getSheet 'Sample', (e, sheet)=>
      return cb.apply @, [e, sheet]

  getRows: (wsId, cb)->
    @gs.getRows wsId, (e, data)=>
      return cb.apply @, [e, data]

  getSheet: (sheetName, cb)->
    returnSheet = ()=>
      ws = _.find @workSheets, {title: sheetName}
      return cb.apply @, [null, ws]
    
    return returnSheet() if @workSheets?

    @getInfo (e)=>
      return cb.apply @, [e] if e?
      return returnSheet()

  setSheet: (sheetName, data, cb)->


module.exports = Sheets
Export2XL = require __dirname + '/../../../../src/models/export2xl'

data = {
  'raghavendhrak-daily-sales': {
    project: { id: 107486, name: 'Daily Sales' },
    sprint: {
      id: 58547,
      name: 'Sprint 1',
      from: '2016-02-11',
      to: '2016-02-25'
    },
    user_stories: [{
      subject: 'Check for the time log',
      ref: 1,
      us_id: 528197,
      time_log: {
        RaghavendhraK: {
          full_name: 'Raghavendra Karunanidhi',
          'hh:mm': '10:40',
          in_hrs: '10.67',
          in_mins: 640
        }
      }
    }],
    users: {
      RaghavendhraK: 'Raghu'
      NavyaHK: 'Navya'
      Kirthan: 'Kirthan'
      Kailash: 'Kailash'
      Shruti: 'Shruti'
      Abhi: 'Abhi'
      Rich: 'Rich'
    }
  }
}
Export2XL.createXLs data, (e)->
  console.log e
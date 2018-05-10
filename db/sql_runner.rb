require('pg')

class SqlRunner

  def self.run(sql, values = [])
    begin
      db = PG.connect( {
        dbname: 'dcgp30nliqvs6l',
        host: 'ec2-23-23-248-192.compute-1.amazonaws.com
',
        port: '5432',
        password: '0c5d85f86ffe9156cf08c6e8212d8fac43733f4c42652dbf92851b9b3cb0c018',
        user: 'ppuzacpmccnkcs' } )
      db.prepare("query", sql)
      result = db.exec_prepared("query", values)
    ensure
      db.close() if db != nil
    end
    return result
  end

end

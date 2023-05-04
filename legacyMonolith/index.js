const express = require('express')
const oracledb = require('oracledb');
const server = express()

const oracleConnection = async () => {
    let pool
    try {
        pool = await oracledb.createPool({
            user          : "hr",
            password      : mypw  // mypw contains the hr schema password
            connectString : "localhost/XEPDB1"
          });
      
          let connection;
          try {
            connection = await pool.getConnection();
            result = await connection.execute(`SELECT last_name FROM employees`);
            console.log("Result is:", result);
          } catch (err) {
            throw (err);
          } finally {
            if (connection) {
              try {
                await connection.close(); // Put the connection back in the pool
              } catch (err) {
                throw (err);
              }
            }
          }
        } catch (err) {
          console.error(err.message);
        } finally {
          await pool.close();
        }  
    }
}

//Starts the web server
server.listen(8080, (req,res) => {
    console.log("server listening")
})


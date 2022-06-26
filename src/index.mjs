import dotenv from 'dotenv'
import express from 'express'
import figlet from 'figlet'
import redis from 'redis'

// Load .env

dotenv.config({ override: true })
delete process.env.GH_TOKEN

// Connect Redis

const client = redis.createClient({ url: process.env.REDIS_URL })
await client.connect();

// Start express app

const app = express()

app.get('/', async (req, res) => {
  const count = await client.incr('count');
  const text = figlet.textSync(`Hello ${count}`)
  res.contentType('html')
  res.send(`<pre>${text}</pre>`)
})

app.listen(3000, () => {
  console.log(`App listening`)
})

TerminalSession = require '../lib/terminal-session'

describe "TerminalSession", ->
  session = null

  beforeEach ->
    session = new TerminalSession('~')
    waitsFor "initial terminal data event", (done) -> session.one 'data', done

  afterEach ->
    session?.destroy()

  describe "exiting shell", ->
    it "emits the exit event", ->
      session.input("exit\n")
      waitsFor "data event response to input",(done) ->
        session.on "exit", ->
          done()

  describe "input", ->
    it "sends inputs to terminal process", ->
      session.input("echo a\n")
      waitsFor "data event response to input",(done) ->
        session.one 'data', (data) ->
          expect(data).toContain "echo a\r\na\r\n"
          done()

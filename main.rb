require 'midilib'

seq = MIDI::Sequence.new()

File.open('input.mid', 'rb') { | file |
  seq.read(file) { | track, num_tracks, i |
    puts "read track #{i} of #{num_tracks}"
  }
}

seq.each { | track |
  track.each { | event |
    if event.class == MIDI::ProgramChange
      event.program = 19
    elsif event.class == MIDI::Tempo
      event.data = (event.data * 1.20).to_i
    elsif event.kind_of?(MIDI::NoteEvent) && event.channel == 9
      event.velocity = 0
    end
  }
  track.recalc_times
}

File.open('output.mid', 'wb') { | file | seq.write(file) }

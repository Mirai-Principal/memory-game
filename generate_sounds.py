import wave
import struct
import math
import os

def generate_wav(filename, freq_duration_vol_list):
    sample_rate = 44100
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)
        
        for freq, duration, vol in freq_duration_vol_list:
            num_samples = int(sample_rate * duration)
            for i in range(num_samples):
                # Square wave for 8-bit feel
                t = float(i) / sample_rate
                if freq == 0:
                    sample = 0
                else:
                    period = 1.0 / freq
                    sample = vol if (t % period) < (period / 2) else -vol
                
                # Apply simple envelope (fade out)
                envelope = 1.0 - (i / num_samples)
                sample = int(sample * envelope * 32767.0)
                wav_file.writeframes(struct.pack('h', sample))

# 1. Flip sound: short, mid pitch
generate_wav('assets/sounds/flip.wav', [(440.0, 0.05, 0.2)])

# 2. Match sound: happy chime (C, E, G)
generate_wav('assets/sounds/match.wav', [
    (523.25, 0.1, 0.3), # C5
    (659.25, 0.1, 0.3), # E5
    (783.99, 0.2, 0.3)  # G5
])

# 3. Error sound: low buzz
generate_wav('assets/sounds/error.wav', [(150.0, 0.2, 0.3)])

# 4. Win sound: arpeggio up
generate_wav('assets/sounds/win.wav', [
    (523.25, 0.1, 0.3), # C5
    (659.25, 0.1, 0.3), # E5
    (783.99, 0.1, 0.3), # G5
    (1046.50, 0.4, 0.3) # C6
])

print("Sounds generated in assets/sounds/")

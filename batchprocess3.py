from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
import itertools



list_files = ["/data/scratch/bt211065/20220324_Researchproject/ERS561394/ERR925008_1.fastq", "/data/scratch/bt211065/20220324_Researchproject/ERS561394/ERR925008_2.fastq"]


# generator function 
def make_batch(seq_object, num_chunks):
  record = True
  intobj = iter(seq_object)
  while record: 
    chunks = [] # append item of generator to list 
    while len(chunks) < num_chunks:  # lenghth of chunks less than num of reads  which is batch size 
      try:
        record = next(intobj) # ouput item in each iteration for each loop 
      except StopIteration:
        record = None # stop iteration at end of iterator object
      if record is None:
        break # stop loop
      chunks.append(record) # append record(bacth size)  to chunks
    if chunks: # if chucks is not
      yield chunks # output chuncks 
        

def batchsize(files):
  list_sizes = []
  for i in list_files:
    fn= open(i , 'r')
    total = 0
    for line in fn :
      line = line.rstrip()
      if line.startswith('@ERR'):
        counter= 1
        total+=counter
    batch = total//3
    list_sizes.append(batch)
  return list_sizes

#print(batchsize(list_files))

def make_files(files):
  counter = 1
  for i,size in zip(files, batchsize(files)):
    seqobj= SeqIO.parse(open(i), 'fastq')
    for x, chunks in enumerate(make_batch(seqobj, size)):
      fname = str(counter)+'Batch'+ str(x) + '.fastq'
      with open(fname, 'w') as f:
        SeqIO.write(chunks, f, 'fastq')
    counter+=1

# OUTPUT SAME FILE SIZE  1051053353 as intial file 
# all 3 batch files is made up of 1051053353


print(make_files(list_files))
  
  
  

      
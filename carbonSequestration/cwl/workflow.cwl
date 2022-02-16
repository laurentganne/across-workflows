cwlVersion: v1.2
class: Workflow
inputs:
  dataset_url: string
  dataset_name: string
  input_deck: string
outputs:
  results:
    type: File[]
    outputSource: opmflow/flow_output
steps:
  download:
    run:
      class: CommandLineTool
      baseCommand: ['curl']
      arguments:
        - position: 1
          valueFrom: '$(inputs.input_url)/$(inputs.input_file_name)'
        - position: 2
          valueFrom: '--location'
        - position: 3
          valueFrom: '$(inputs.input_file_name)'
          prefix: '--output'
      inputs:
        input_url:
          type: string
        input_file_name: 
          type: string
      outputs:
        downloaded_file:
          type: File        
          outputBinding:  
              glob: $(inputs.input_file_name)
    in:
      input_url: dataset_url
      input_file_name: dataset_name
    out: [downloaded_file]
  unzip:
    run:
      class: CommandLineTool
      baseCommand: ['unzip']
      inputs:
        input_file:
          type: File
          inputBinding:
            position: 0
      outputs:
        unzipped_files:
          type: File[] 
          outputBinding:
            glob: "*"
    in:
      input_file: download/downloaded_file
    out: [unzipped_files]
  opmflow:
    run:
      class: CommandLineTool
      baseCommand: ['flow']
      requirements:
        InitialWorkDirRequirement:
          listing:          
            - $(inputs.input_files)
      stdout: output_flow.log
      arguments:
        - position: 1
          valueFrom: '--output-dir=$(runtime.outdir)/output'
        - position: 2
          valueFrom: '$(runtime.outdir)/$(inputs.input_deck_path)'
      inputs:
        input_files:
          type: File[]
        input_deck_path:
          type: string
      outputs:
        flow_output:
          type: File[]
          outputBinding:  
              glob: "output*"
    in:
      input_files: unzip/unzipped_files
      input_deck_path: input_deck
    out: [flow_output]

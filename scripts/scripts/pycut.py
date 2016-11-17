#!/usr/bin/python

import fileinput
import re

delimiter = None
output_delimiter = " "

def seprate(line, fieldsarg) :
    content = line.split()
    output = []

    fields = fieldsarg.split(",")
    for index in fields :
        if re.match("\d+", index):
            output.append(content[int(index)])
        else:
            m = re.match("(\d*)-(\d*)")
            start = m.group(1) if m.group(1) != "" else None
            end = m.group(2) if m.group(2) != "" else None
            output.extend(content[start:end])

    return output

def outformat(inputlines, delimiter = " ") :
    lengthperline = [0]*100
    for line in inputlines:
        for i in range(len(line)):
            if len(line[i]) > lengthperline[i]:
                lengthperline[i] = len(line[i])

    lengthperline = map(lambda x:"%%%dd" % x if x != 0 else "", lengthperline)
    return delimiter.join(lengthperline)

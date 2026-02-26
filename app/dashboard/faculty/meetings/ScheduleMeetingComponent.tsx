"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog"
import { Label } from "@/components/ui/label"
import { Input } from "@/components/ui/input"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Plus } from "lucide-react"
import { FormWithToast } from "@/components/ui/form-with-toast"
import { createMeeting } from "@/app/actions/faculty"

interface ScheduleMeetingComponentProps {
    projects: { id: string; title: string }[]
}

export function ScheduleMeetingComponent({ projects }: ScheduleMeetingComponentProps) {
    const [open, setOpen] = useState(false)

    return (
        <Dialog open={open} onOpenChange={setOpen}>
            <DialogTrigger asChild>
                <Button className="bg-gradient-to-r from-cyan-500 to-blue-500 text-white shadow-lg shadow-cyan-500/25">
                    <Plus className="mr-2 h-4 w-4" /> Schedule Meeting
                </Button>
            </DialogTrigger>
            <DialogContent className="glass-modern border-cyan-500/20">
                <DialogHeader>
                    <DialogTitle>Schedule New Meeting</DialogTitle>
                    <DialogDescription>Set up a meeting with a project group.</DialogDescription>
                </DialogHeader>
                <FormWithToast
                    action={async (formData) => {
                        const projectId = formData.get("projectId") as string
                        const title = formData.get("title") as string
                        const dateStr = formData.get("date") as string
                        return await createMeeting(projectId, title, new Date(dateStr))
                    }}
                    onSuccess={() => setOpen(false)}
                    successMessage="Meeting scheduled successfully"
                >
                    <div className="grid gap-4 py-4">
                        <div className="space-y-2">
                            <Label htmlFor="projectId">Project Group</Label>
                            <Select name="projectId" required>
                                <SelectTrigger className="bg-white/5 border-cyan-500/20">
                                    <SelectValue placeholder="Select project" />
                                </SelectTrigger>
                                <SelectContent>
                                    {projects.map(p => (
                                        <SelectItem key={p.id} value={p.id}>{p.title}</SelectItem>
                                    ))}
                                </SelectContent>
                            </Select>
                        </div>
                        <div className="space-y-2">
                            <Label htmlFor="title">Meeting Title</Label>
                            <Input id="title" name="title" placeholder="e.g., Sprint Review 1" required className="bg-white/5 border-cyan-500/20" />
                        </div>
                        <div className="space-y-2">
                            <Label htmlFor="date">Date & Time</Label>
                            <Input id="date" name="date" type="datetime-local" required className="bg-white/5 border-cyan-500/20" />
                        </div>
                    </div>
                    <DialogFooter>
                        <Button type="submit" className="bg-cyan-600 hover:bg-cyan-700 text-white">Schedule</Button>
                    </DialogFooter>
                </FormWithToast>
            </DialogContent>
        </Dialog>
    )
}

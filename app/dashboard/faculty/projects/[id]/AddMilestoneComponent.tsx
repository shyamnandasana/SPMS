"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog"
import { Label } from "@/components/ui/label"
import { Input } from "@/components/ui/input"
import { Plus } from "lucide-react"
import { FormWithToast } from "@/components/ui/form-with-toast"
import { createMilestone } from "@/app/actions/faculty"

interface AddMilestoneComponentProps {
    projectId: string
}

export function AddMilestoneComponent({ projectId }: AddMilestoneComponentProps) {
    const [open, setOpen] = useState(false)

    return (
        <Dialog open={open} onOpenChange={setOpen}>
            <DialogTrigger asChild>
                <Button size="sm" className="bg-gradient-to-r from-cyan-500 to-blue-500 text-white">
                    <Plus className="mr-2 h-4 w-4" /> Add Milestone
                </Button>
            </DialogTrigger>
            <DialogContent className="glass-modern border-cyan-500/20">
                <DialogHeader>
                    <DialogTitle>Add New Milestone</DialogTitle>
                    <DialogDescription>Set a key deliverable and deadline for the project.</DialogDescription>
                </DialogHeader>
                <FormWithToast
                    action={async (formData) => {
                        const title = formData.get("title") as string
                        const dateStr = formData.get("deadline") as string
                        return await createMilestone(projectId, title, new Date(dateStr))
                    }}
                    onSuccess={() => setOpen(false)}
                    successMessage="Milestone created successfully!"
                >
                    <div className="grid gap-4 py-4">
                        <div className="space-y-2">
                            <Label htmlFor="title">Milestone Title</Label>
                            <Input id="title" name="title" placeholder="e.g., Database Design" required className="bg-white/5 border-cyan-500/20" />
                        </div>
                        <div className="space-y-2">
                            <Label htmlFor="deadline">Deadline</Label>
                            <Input id="deadline" name="deadline" type="date" required className="bg-white/5 border-cyan-500/20" />
                        </div>
                    </div>
                    <DialogFooter>
                        <Button type="submit" className="bg-cyan-600 hover:bg-cyan-700 text-white">Add Milestone</Button>
                    </DialogFooter>
                </FormWithToast>
            </DialogContent>
        </Dialog>
    )
}
